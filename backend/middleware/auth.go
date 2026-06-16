package middleware

import (
	"esor-backend/utils"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

// AuthMiddleware sprawdza poprawność tokenu JWT w nagłówku żądania
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Brak nagłówka Authorization"})
			c.Abort()
			return
		}

		// Nagłówek powinien mieć format: Bearer <token>
		parts := strings.SplitN(authHeader, " ", 2)
		if !(len(parts) == 2 && parts[0] == "Bearer") {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Niepoprawny format nagłówka Authorization (wymagany Bearer)"})
			c.Abort()
			return
		}

		tokenString := parts[1]

		// Walidacja tokenu za pomocą naszej funkcji z utils
		claims, err := utils.ValidateToken(tokenString)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Nieprawidłowy lub przedawniony token dostępu"})
			c.Abort()
			return
		}

		// Zapisujemy ID użytkownika oraz jego rolę w kontekście Gina, 
		// dzięki czemu kolejne kontrolery będą wiedziały, kto wykonuje akcję
		c.Set("userID", claims.UserID)
		c.Set("userRole", claims.Role)

		c.Next()
	}
}


func RoleBlockMiddleware(allowedRoles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Wyciągamy rolę zapisaną wcześniej przez AuthMiddleware
		role, exists := c.Get("userRole")
		if !exists {
			c.JSON(http.StatusForbidden, gin.H{"error": "Brak zdefiniowanej roli w kontekście autoryzacji"})
			c.Abort()
			return
		}

		userRoleStr := role.(string)

		// Sprawdzamy, czy rola użytkownika jest na liście ról dozwolonych dla tego endpointu
		isAllowed := false
		for _, allowedRole := range allowedRoles {
			if userRoleStr == allowedRole {
				isAllowed = true
				break
			}
		}

		if !isAllowed {
			c.JSON(http.StatusForbidden, gin.H{"error": "Brak uprawnień do wykonania tej operacji (wymagana wyższa rola medyczna)"})
			c.Abort()
			return
		}

		c.Next()
	}
}