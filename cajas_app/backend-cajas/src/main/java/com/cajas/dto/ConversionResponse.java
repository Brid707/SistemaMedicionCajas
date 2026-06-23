package com.cajas.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record ConversionResponse(
        Long id,
        BigDecimal cantidad,
        String unidadCodigo,
        String unidadNombre,
        BigDecimal equivalente,
        BigDecimal resultadoCajas,
        LocalDateTime creadoEn
) {
}
