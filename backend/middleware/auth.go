package middleware

import (
	"esor-backend/utils"
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

// AuthMiddleware sprawdza poprawność tokenu JWT w nagłówku żądania lub w parametrze URL (dla WebSocketów)
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		var tokenString string

		// 1. Sprawdź, czy to połączenie WebSocket (szukamy frazy /ws/ w ścieżce)
		//    i próbuje wyciągnąć token z parametru query (?token=...)
		if strings.Contains(c.Request.URL.Path, "/ws/") {
			tokenString = c.Query("token")
		}

		// 2. Jeśli nie ma w URL (lub to zwykły endpoint HTTP), szukamy standardowo w nagłówku Authorization
		if tokenString == "" {
			authHeader := c.GetHeader("Authorization")
			if authHeader == "" {
				c.JSON(http.StatusUnauthorized, gin.H{"error": "Brak nagłówka Authorization lub parametru token"})
				c.Abort()
				return
			}

			parts := strings.SplitN(authHeader, " ", 2)
			if !(len(parts) == 2 && parts[0] == "Bearer") {
				c.JSON(http.StatusUnauthorized, gin.H{"error": "Niepoprawny format nagłówka Authorization (wymagany Bearer)"})
				c.Abort()
				return
			}

			tokenString = parts[1]
		}

		// 3. Walidacja wyciągniętego tokenu
		claims, err := utils.ValidateToken(tokenString)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Nieprawidłowy lub przedawniony token dostępu"})
			c.Abort()
			return
		}

		// Zapisujemy ID oraz Rolę w kontekście
		c.Set("userID", claims.UserID)
		c.Set("userRole", claims.Role)

		c.Next()
	}
}

// RoleBlockMiddleware pozwala na elastyczne mieszanie ról dostępowych
func RoleBlockMiddleware(allowedRoles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		role, exists := c.Get("userRole")
		if !exists {
			c.JSON(http.StatusForbidden, gin.H{"error": "Brak zdefiniowanej roli w kontekście autoryzacji"})
			c.Abort()
			return
		}

		// Bezpieczna konwersja na string (zadziała niezależnie czy to string, czy models.Role)
		userRoleStr := fmt.Sprintf("%v", role)

		// Sprawdzamy, czy rola użytkownika znajduje się w przekazanej tablicy ról
		isAllowed := false
		for _, allowedRole := range allowedRoles {
			if userRoleStr == allowedRole {
				isAllowed = true
				break
			}
		}

		if !isAllowed {
			c.JSON(http.StatusForbidden, gin.H{"error": "Brak uprawnień do wykonania tej operacji"})
			c.Abort()
			return
		}

		c.Next()
	}
}