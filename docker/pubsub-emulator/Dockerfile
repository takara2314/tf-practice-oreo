FROM google/cloud-sdk:latest

WORKDIR /app

RUN git clone https://github.com/googleapis/python-pubsub.git

WORKDIR /app/python-pubsub/samples/snippets/

RUN pip install -r requirements.txt

EXPOSE 8085

CMD [ "gcloud", "beta", "emulators", "pubsub", "start", "--project", "tf-practice-oreo" ]
