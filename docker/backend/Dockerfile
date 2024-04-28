# Building image
FROM golang:1.22.2-alpine AS builder

WORKDIR /app

COPY . .

RUN go build -o main -ldflags="-s -w" -trimpath ./cmd/oreo/main.go


# Production image
FROM gcr.io/distroless/static-debian12 AS production

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 8080

CMD [ "./main" ]
