// main_test.go
package main

import (
    "context"
    "testing"
    "github.com/redis/go-redis/v9"
)

func TestRedis(t *testing.T) {
    rdb := redis.NewClient(&redis.Options{
        Addr: "localhost:6379",
    })

    err := rdb.Set(context.Background(), "testkey", "testvalue", 0).Err()
    if err != nil {
        t.Fatalf("could not set key in Redis: %v", err)
    }

    val, err := rdb.Get(context.Background(), "testkey").Result()
    if err != nil {
        t.Fatalf("could not get key from Redis: %v", err)
    }

    if val != "testvalue" {
        t.Errorf("expected 'testvalue', got %s", val)
    }
}

