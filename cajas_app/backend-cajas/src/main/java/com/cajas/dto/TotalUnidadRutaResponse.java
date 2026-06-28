package com.cajas.dto;

import java.math.BigDecimal;

public record TotalUnidadRutaResponse(
        String unidadCodigo,
        String unidadNombre,
        BigDecimal totalCantidad,
        BigDecimal totalCajas
) {
}