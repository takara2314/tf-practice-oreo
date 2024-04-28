pubsub_create_publisher:
	docker compose exec pubsub-emulator python3 publisher.py tf-practice-oreo create oreo-news

pubsub_create_subscription:
	docker compose exec pubsub-emulator python3 subscriber.py tf-practice-oreo create-push oreo-news oreo-news-sub http://backend:8080
