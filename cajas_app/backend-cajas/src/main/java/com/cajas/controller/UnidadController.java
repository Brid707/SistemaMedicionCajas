package com.cajas.controller;

import com.cajas.dto.UnidadResponse;
import com.cajas.service.UnidadService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/unidades")
public class UnidadController {

    private final UnidadService unidadService;

    public UnidadController(UnidadService unidadService) {
        this.unidadService = unidadService;
    }

    @GetMapping
    public List<UnidadResponse> obtenerUnidades() {
        return unidadService.obtenerUnidades();
    }
}
