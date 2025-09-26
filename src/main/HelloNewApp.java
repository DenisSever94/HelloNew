package main;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class HelloNewApp {

    public static void main(String[] args) {
        SpringApplication.run(HelloNewApp.class, args);
    }

    @GetMapping("/")
    public String hello() {
        return "Hello from Spring Boot! CI/CD Pipeline is working! 🚀";
    }

    @GetMapping("/health")
    public String health() {
        return "{\"status\": \"UP\"}";
    }
}