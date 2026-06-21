package controllers

import (
	"esor-backend/config"
	"esor-backend/models"
	"log"
	"net/http"
	"sync"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

// Konfiguracja Upgradera połączenia HTTP -> WS
var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	// Pozwalamy na połączenia z Fluttera/zewnętrznych adresów (CORS)
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

// QueueHub zarządza aktywnymi połączeniami WebSocket dla personelu (pełne dane)
type QueueHub struct {
	clients map[*websocket.Conn]bool
	mu      sync.Mutex
}

// Globalna instancja Hub'a dla personelu
var ActiveQueueHub = &QueueHub{
	clients: make(map[*websocket.Conn]bool),
}

// Struktura okrojona pod RODO (Tylko bilet i kolor/KTAS na TV)
type PublicQueueTicket struct {
	ID           uint `json:"numer_biletu"`
	PriorityKTAS int  `json:"priority_ktas"`
}

// Globalny hub dla publicznych ekranów TV (Anonimowe dane)
var PublicQueueHub = struct {
	clients map[*websocket.Conn]bool
	sync.Mutex
}{
	clients: make(map[*websocket.Conn]bool),
}

// Funkcja pomocnicza: Pobiera z bazy aktualny stan pełnej kolejki
func fetchCurrentQueue() ([]models.Admission, error) {
	var queue []models.Admission
	err := config.DB.Where("status_przyjecia = ?", models.StatusWPoczekalni).
		Order("priority_ktas ASC, data_przyjecia ASC").
		Find(&queue).Error
	return queue, err
}

// Funkcja pomocnicza: Pobiera i mapuje dane pod RODO dla pojedynczego ekranu TV
func fetchPublicQueueTickets() ([]PublicQueueTicket, error) {
	var admissions []models.Admission
	err := config.DB.Select("id", "priority_ktas").
		Where("status_przyjecia = ?", models.StatusWPoczekalni).
		Order("priority_ktas ASC, data_przyjecia ASC").
		Find(&admissions).Error

	if err != nil {
		return nil, err
	}

	publicTickets := make([]PublicQueueTicket, len(admissions))
	for i, adm := range admissions {
		publicTickets[i] = PublicQueueTicket{
			ID:           adm.ID,
			PriorityKTAS: adm.PriorityKtas,
		}
	}
	return publicTickets, nil
}

// WS /api/ws/admissions/queue
// Handler dla zalogowanego personelu medycznego (Pełne dane pacjentów)
func StreamQueue(c *gin.Context) {
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Printf("[WS ERROR] Nie udało się podnieść połączenia do WS dla personelu: %v", err)
		return
	}

	ActiveQueueHub.mu.Lock()
	ActiveQueueHub.clients[conn] = true
	ActiveQueueHub.mu.Unlock()

	log.Printf("[WS] Nowy personel medyczny podłączony. Łącznie: %d", len(ActiveQueueHub.clients))

	// Natychmiastowy push aktualnego stanu po połączeniu
	if queue, err := fetchCurrentQueue(); err == nil {
		_ = conn.WriteJSON(queue)
	}

	// Pętla utrzymująca socket i monitorująca rozłączenie
	go func() {
		defer func() {
			ActiveQueueHub.mu.Lock()
			delete(ActiveQueueHub.clients, conn)
			ActiveQueueHub.mu.Unlock()
			conn.Close()
			log.Println("[WS] Klient (personel) odłączył się od kolejki.")
		}()

		for {
			if _, _, err := conn.ReadMessage(); err != nil {
				break
			}
		}
	}()
}

// WS /api/ws/admissions/public-queue
// Handler dla publicznych telewizorów w poczekalni (Dane zanonimizowane pod RODO)
func HandlePublicQueueWebSocket(c *gin.Context) {
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Printf("[WS ERROR] Nie udało się podnieść połączenia do WS dla TV: %v", err)
		return
	}

	PublicQueueHub.Lock()
	PublicQueueHub.clients[conn] = true
	PublicQueueHub.Unlock()

	log.Printf("[WS] Nowy telewizor poczekalni podłączony. Łącznie: %d", len(PublicQueueHub.clients))

	// Natychmiastowy push biletów RODO po połączeniu
	if tickets, err := fetchPublicQueueTickets(); err == nil {
		_ = conn.WriteJSON(tickets)
	}

	// Pętla utrzymująca socket dla telewizora
	go func() {
		defer func() {
			PublicQueueHub.Lock()
			delete(PublicQueueHub.clients, conn)
			PublicQueueHub.Unlock()
			conn.Close()
			log.Println("[WS] Telewizor poczekalni odłączył się od strumienia.")
		}()

		for {
			if _, _, err := conn.ReadMessage(); err != nil {
				break
			}
		}
	}()
}

// BroadcastQueue pobiera najświeższe dane i asynchronicznie aktualizuje oba Huby (Personel + TV)
func BroadcastQueue() {
	// 1. Aktualizacja Hubu personelu medycznego
	ActiveQueueHub.mu.Lock()
	if len(ActiveQueueHub.clients) > 0 {
		queue, err := fetchCurrentQueue()
		if err == nil {
			for client := range ActiveQueueHub.clients {
				if err := client.WriteJSON(queue); err != nil {
					client.Close()
					delete(ActiveQueueHub.clients, client)
				}
			}
		}
	}
	ActiveQueueHub.mu.Unlock()

	// 2. Aktualizacja Hubu Telewizorów (Zgodność z RODO)
	PublicQueueHub.Lock()
	if len(PublicQueueHub.clients) > 0 {
		tickets, err := fetchPublicQueueTickets()
		if err == nil {
			for client := range PublicQueueHub.clients {
				if err := client.WriteJSON(tickets); err != nil {
					client.Close()
					delete(PublicQueueHub.clients, client)
				}
			}
		}
	}
	PublicQueueHub.Unlock()
}