package main

import (
	"context"
	"fmt"
	"log"

	"cloud.google.com/go/pubsub"
	"github.com/gin-gonic/gin"
	"github.com/takara2314/tf-practice-oreo/app/common"
	"github.com/takara2314/tf-practice-oreo/app/presentation/handler"
)

func main() {
	log.Println("Hello oreoだよ!")

	ctx := context.Background()

	if err := common.InitPubSub(ctx); err != nil {
		log.Fatalf("Failed to create pubsub client: %v", err)
	}

	router := gin.Default()

	router.GET("/", handler.HelloWorld)
	router.GET("/oreo", handler.GetOreo)

	go func() {
		err := common.Sub.Receive(ctx, func(ctx context.Context, msg *pubsub.Message) {
			log.Printf("Got message: %q\n", string(msg.Data))
			msg.Ack()
		})
		if err != nil {
			log.Fatalf("Failed to receive message: %v", err)
		}
	}()

	fmt.Println("ルーターを起動しました！")

	if err := router.Run(":8080"); err != nil {
		log.Fatalf("Failed to run server: %v", err)
	}
}
