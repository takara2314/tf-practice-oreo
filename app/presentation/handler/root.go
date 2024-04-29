package handler

import (
	"log"
	"net/http"

	"cloud.google.com/go/pubsub"
	"github.com/gin-gonic/gin"
	"github.com/takara2314/tf-practice-oreo/app/common"
)

func HelloWorld(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "こんにちは！オレオ！",
	})
}

func GetOreo(c *gin.Context) {
	result := common.Topic.Publish(c, &pubsub.Message{
		Data: []byte("oreo"),
	})
	id, err := result.Get(c)
	if err != nil {
		log.Fatalf("Failed to publish message: %v", err)
	}
	log.Println("Published a message; msg ID: ", id)

	c.JSON(http.StatusOK, gin.H{
		"message": "オレオを取得しました！",
	})
}
