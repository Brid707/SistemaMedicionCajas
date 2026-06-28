package com.cajas.controller;

import com.cajas.dto.RutaResponse;
import com.cajas.dto.TotalUnidadRutaResponse;
import com.cajas.model.Usuario;
import com.cajas.service.RutaService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rutas")
public class RutaController {

    private final RutaService rutaService;

    public RutaController(RutaService rutaService) {
        this.rutaService = rutaService;
    }

    @PostMapping("/nueva")
    public RutaResponse crearRutaNueva(
            @AuthenticationPrincipal Usuario usuario
    ) {
        return rutaService.crearRutaNueva(usuario);
    }

    @GetMapping("/activa")
    public RutaResponse obtenerRutaActiva(
            @AuthenticationPrincipal Usuario usuario
    ) {
        return rutaService.obtenerRutaActiva(usuario);
    }

    @GetMapping
    public List<RutaResponse> listarRutas(
            @AuthenticationPrincipal Usuario usuario
    ) {
        return rutaService.listarRutas(usuario);
    }

    @GetMapping("/{id}")
    public RutaResponse obtenerRutaPorId(
            @PathVariable Long id,
            @AuthenticationPrincipal Usuario usuario
    ) {
        return rutaService.obtenerRutaPorId(id, usuario);
    }

    @GetMapping("/{id}/totales")
    public List<TotalUnidadRutaResponse> obtenerTotalesPorUnidad(
            @PathVariable Long id,
            @AuthenticationPrincipal Usuario usuario
    ) {
        return rutaService.obtenerTotalesPorUnidad(id, usuario);
    }

    @PostMapping("/{id}/finalizar")
    public RutaResponse finalizarRuta(
            @PathVariable Long id,
            @AuthenticationPrincipal Usuario usuario
    ) {
        return rutaService.finalizarRuta(id, usuario);
    }
}