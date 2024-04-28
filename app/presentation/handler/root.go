package handler

import "github.com/gin-gonic/gin"

func HelloWorld(c *gin.Context) {
	c.String("Hello oreo!")
}
