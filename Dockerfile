# Stage 1: Build
FROM golang:1.23 AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o myapp main.go

# Install gotestsum
RUN go install gotest.tools/gotestsum@latest

# Stage 2: Final
FROM alpine:latest

WORKDIR /root/
COPY --from=build /app/myapp .
COPY --from=build /go/bin/gotestsum /usr/local/bin/gotestsum

ENTRYPOINT ["/myapp"]
