package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/takara2314/tf-practice-oreo/app/presentation/handler"
)

func main() {
	log.Println("Hello oreo!")

	router := gin.Default()

	router.GET("/", handler.HelloWorld)

	if err := router.Run(":8080"); err != nil {
		log.Fatalf("Failed to run server: %v", err)
	}
}
