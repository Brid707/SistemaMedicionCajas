package com.cajas.controller;

import com.cajas.dto.ClienteResponse;
import com.cajas.dto.ConversionRequest;
import com.cajas.model.Usuario;
import com.cajas.service.ClienteService;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/clientes")
public class ClienteController {

    private final ClienteService clienteService;

    public ClienteController(ClienteService clienteService) {
        this.clienteService = clienteService;
    }

    @PostMapping("/nuevo")
    public ClienteResponse crearNuevoCliente(@AuthenticationPrincipal Usuario usuario) {
        return clienteService.crearNuevoCliente(usuario);
    }

    @GetMapping("/activo")
    public ClienteResponse obtenerClienteActivo(@AuthenticationPrincipal Usuario usuario) {
        return clienteService.obtenerClienteActivo(usuario);
    }

    @PostMapping("/{id}/conversiones")
    public ClienteResponse agregarConversion(
            @PathVariable Long id,
            @Valid @RequestBody ConversionRequest request,
            @AuthenticationPrincipal Usuario usuario
    ) {
        return clienteService.agregarConversion(id, request, usuario);
    }

    @PostMapping("/{id}/finalizar")
    public ClienteResponse finalizarCliente(
            @PathVariable Long id,
            @AuthenticationPrincipal Usuario usuario
    ) {
        return clienteService.finalizarCliente(id, usuario);
    }
}