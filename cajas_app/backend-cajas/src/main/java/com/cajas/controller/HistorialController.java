package com.cajas.controller;

import com.cajas.dto.ClienteResponse;
import com.cajas.dto.TotalDiaResponse;
import com.cajas.model.Usuario;
import com.cajas.service.ClienteService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/historial")
public class HistorialController {

    private final ClienteService clienteService;

    public HistorialController(ClienteService clienteService) {
        this.clienteService = clienteService;
    }

    @GetMapping
    public List<ClienteResponse> obtenerHistorial48Horas(
            @AuthenticationPrincipal Usuario usuario
    ) {
        return clienteService.obtenerHistorial48Horas(usuario);
    }

    @GetMapping("/dia")
    public TotalDiaResponse obtenerTotalDelDia(
            @AuthenticationPrincipal Usuario usuario,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate fecha
    ) {
        if (fecha == null) {
            return clienteService.obtenerTotalDelDia(usuario);
        }

        return clienteService.obtenerTotalPorFecha(usuario, fecha);
    }

    @GetMapping("/fecha")
    public List<ClienteResponse> obtenerHistorialPorFecha(
            @AuthenticationPrincipal Usuario usuario,
            @RequestParam
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate fecha
    ) {
        return clienteService.obtenerHistorialPorFecha(usuario, fecha);
    }

    @GetMapping("/clientes/{id}")
    public ClienteResponse obtenerClientePorId(
            @PathVariable Long id,
            @AuthenticationPrincipal Usuario usuario
    ) {
        return clienteService.obtenerClientePorId(id, usuario);
    }
}