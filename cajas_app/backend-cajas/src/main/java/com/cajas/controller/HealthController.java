package com.cajas.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
public class HealthController {

    @GetMapping("/api/health")
    public Map<String, Object> health() {
        return Map.of(
                "success", true,
                "message", "Backend de Cajas funcionando correctamente",
                "app", "backend-cajas",
                "timestamp", LocalDateTime.now()
        );
    }
}
