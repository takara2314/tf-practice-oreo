# Building image
FROM golang:1.22.2-alpine AS builder

WORKDIR /app

COPY . .

RUN go build -o main -ldflags="-s -w" -trimpath ./cmd/oreo/main.go


# Local development image
FROM golang:1.22.2-alpine AS development

WORKDIR /app

COPY . .

RUN apk add --no-cache curl

RUN go install github.com/cosmtrek/air@latest

EXPOSE 8080

CMD ["air", "-c", "./docker/backend/.air.toml"]


# Production image
FROM gcr.io/distroless/static-debian12 AS production

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 8080

CMD [ "./main" ]
