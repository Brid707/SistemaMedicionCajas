package com.cajas.dto;

public record UsuarioResponse(
        Long id,
        String nombre,
        String correo
) {
}
