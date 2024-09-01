# Start with a base Go image
FROM golang:1.23-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the container
COPY go.mod go.sum ./

# Download Go module dependencies
RUN go mod download

# Copy the rest of the application code to the container
COPY . .

# Build the Go application
RUN go build -o myapp main.go

# Set the command to run the application
CMD ["./myapp"]

# Expose the port the application will run on
EXPOSE 8080

