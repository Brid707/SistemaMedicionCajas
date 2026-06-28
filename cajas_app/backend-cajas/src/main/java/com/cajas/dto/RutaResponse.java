package com.cajas.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record RutaResponse(
        Long id,
        String folioRuta,
        String estado,
        BigDecimal totalCajas,
        LocalDateTime creadoEn,
        LocalDateTime finalizadoEn,
        List<ClienteResponse> clientes,
        List<TotalUnidadRutaResponse> totalesPorUnidad
) {
}