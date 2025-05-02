package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MessageController {
    // Root path endpoint
    @GetMapping("/")
    public String home() {
        return "Welcome to My First Spring Boot Application!";
    }

    // Additional endpoint for demonstration
    @GetMapping("/hello")
    public String hello() {
        return "Hello, World! This is a simple Spring Boot message.";
    }

    // Fun endpoint with current time
    @GetMapping("/time")
    public String currentTime() {
        return "Current Server Time: " + new java.util.Date().toString();
    }
}