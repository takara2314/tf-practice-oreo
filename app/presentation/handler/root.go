package handler

import (
	"context"
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
	common.Topic.Publish(context.Background(), &pubsub.Message{
		Data: []byte("oreo"),
	})

	c.JSON(http.StatusOK, gin.H{
		"message": "オレオを取得しました！",
	})
}
