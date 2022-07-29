FROM golang:1.18-alpine

WORKDIR /app

ADD go.mod go.sum main.go /app/

RUN go mod download

CMD ["go", "run", "main.go"]
