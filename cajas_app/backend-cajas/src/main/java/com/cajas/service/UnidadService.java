package com.cajas.service;

import com.cajas.dto.UnidadResponse;
import com.cajas.unidad.TipoUnidad;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class UnidadService {

    public List<UnidadResponse> obtenerUnidades() {
        return Arrays.stream(TipoUnidad.values())
                .map(unidad -> new UnidadResponse(
                        unidad.name(),
                        unidad.getNombre(),
                        unidad.getEquivalente()
                ))
                .toList();
    }
}
