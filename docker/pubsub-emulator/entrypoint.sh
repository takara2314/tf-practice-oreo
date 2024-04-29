#!/bin/bash

export PUBSUB_PROJECT_ID=tf-practice-oreo
export TOPIC_ID=oreo-news
export SUBSCRIPTION_ID=oreo-news-sub

gcloud beta emulators pubsub start --project=$PUBSUB_PROJECT_ID --host-port=$PUBSUB_EMULATOR_HOST --quiet &

pubsub_pid=$!

while ! nc -z localhost 8085; do
  sleep 0.1
done

python3 publisher.py $PUBSUB_PROJECT_ID create $TOPIC_ID
python3 subscriber.py $PUBSUB_PROJECT_ID create $TOPIC_ID $SUBSCRIPTION_ID

wait $pubsub_pid
