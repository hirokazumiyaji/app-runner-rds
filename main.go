package main

import (
	"database/sql"
	"fmt"
	"net/http"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"github.com/labstack/echo/v4"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	e := echo.New()

	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]any{"success": true})
	})

	e.GET("/mysql", func(c echo.Context) error {
		dsn := os.Getenv("DATABASE_DSN")
		db, err := sql.Open("mysql", dsn)
		if err != nil {
			return c.JSON(http.StatusOK, map[string]any{"success": false, "err": err.Error()})
		}

		err = db.Ping()
		if err != nil {
			return c.JSON(http.StatusOK, map[string]any{"success": false, "err": err.Error()})
		}
		return c.JSON(http.StatusOK, map[string]any{"success": true})
	})

	e.Logger.Fatal(e.Start(fmt.Sprintf(":%s", port)))
}
