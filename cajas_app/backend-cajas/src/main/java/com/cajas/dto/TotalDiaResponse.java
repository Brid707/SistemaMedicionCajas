package com.cajas.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record TotalDiaResponse(
        LocalDateTime inicioDia,
        LocalDateTime finDia,
        BigDecimal totalCajasDia
) {
}
