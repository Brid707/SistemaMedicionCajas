package com.cajas.dto;

import java.math.BigDecimal;

public record UnidadResponse(
        String codigo,
        String nombre,
        BigDecimal equivalente
) {
}
