package com.cajas.controller;

import com.cajas.dto.AuthResponse;
import com.cajas.dto.LoginRequest;
import com.cajas.dto.RegisterRequest;
import com.cajas.dto.UsuarioResponse;
import com.cajas.model.Usuario;
import com.cajas.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public AuthResponse registrar(@Valid @RequestBody RegisterRequest request) {
        return authService.registrar(request);
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }

    @GetMapping("/me")
    public UsuarioResponse obtenerUsuarioActual(@AuthenticationPrincipal Usuario usuario) {
        if (usuario == null) {
            throw new RuntimeException("Usuario no autenticado");
        }

        return authService.obtenerUsuarioActual(usuario);
    }
}
