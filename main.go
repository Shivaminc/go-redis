// main.go
package main

import (
    "context"
    "fmt"
    "log"

    "github.com/redis/go-redis/v9"
)

var ctx = context.Background()

func main() {
    // Create a new Redis client
    rdb := redis.NewClient(&redis.Options{
        Addr: "host.docker.internal:6379", // Address of the Redis server
    })

    // Ping the Redis server to check the connection
    _, err := rdb.Ping(ctx).Result()
    if err != nil {
        log.Fatalf("could not connect to Redis: %v", err)
    }
    fmt.Println("Connected to Redis")

    // Set a key-value pair
    err = rdb.Set(ctx, "mykey", "myvalue", 0).Err()
    if err != nil {
        log.Fatalf("could not set key in Redis: %v", err)
    }
    fmt.Println("Key set successfully")

    // Get the value of the key
    val, err := rdb.Get(ctx, "mykey").Result()
    if err != nil {
        log.Fatalf("could not get key from Redis: %v", err)
    }
    fmt.Printf("The value of 'mykey' is: %s\n", val)
}

