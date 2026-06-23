package com.cajas.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record ClienteResponse(
        Long id,
        String folioCliente,
        String estado,
        BigDecimal totalCajas,
        LocalDateTime creadoEn,
        LocalDateTime finalizadoEn,
        List<ConversionResponse> conversiones
) {
}
