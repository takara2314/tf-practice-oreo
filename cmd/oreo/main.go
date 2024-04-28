package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/takara2314/oreo/app/presentation/handler"
)

func main() {
	log.Println("Hello oreo!")

	router := gin.Default()

	router.GET("/", handler.HelloWorld)
}
