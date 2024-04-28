package common

import (
	"context"

	"cloud.google.com/go/pubsub"
)

var (
	PubSubClient *pubsub.Client
	Topic        *pubsub.Topic
	Sub          *pubsub.Subscription
)

func InitPubSub(ctx context.Context) error {
	var err error

	PubSubClient, err = pubsub.NewClient(
		ctx,
		"tf-practice-oreo",
	)
	if err != nil {
		return err
	}

	Topic = PubSubClient.Topic("oreo-news")
	Sub = PubSubClient.Subscription("oreo-news-sub")

	return nil
}
