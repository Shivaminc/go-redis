# Use the official Go image from the Docker Hub for building the app
FROM golang:1.23 AS build

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the Go Modules manifests
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app with static linking to avoid glibc issues
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o myapp main.go

# Start a new stage from scratch
FROM debian:alpine

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=build /app/myapp .

# Expose port 9042 to the outside world (if your app listens on this port)
EXPOSE 9042

# Command to run the executable
CMD ["./myapp"]
