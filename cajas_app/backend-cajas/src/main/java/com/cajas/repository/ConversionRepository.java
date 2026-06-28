package com.cajas.repository;

import com.cajas.model.Conversion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ConversionRepository extends JpaRepository<Conversion, Long> {

    List<Conversion> findByClienteIdOrderByCreadoEnAsc(
            Long clienteId
    );

    List<Conversion> findByCliente_Ruta_IdOrderByCreadoEnAsc(
            Long rutaId
    );
}