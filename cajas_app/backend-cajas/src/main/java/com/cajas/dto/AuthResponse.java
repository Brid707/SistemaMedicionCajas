package com.cajas.dto;

public record AuthResponse(
        String token,
        Long usuarioId,
        String nombre,
        String correo
) {
}

