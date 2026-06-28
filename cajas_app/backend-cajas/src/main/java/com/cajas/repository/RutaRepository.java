package com.cajas.repository;

import com.cajas.model.EstadoRuta;
import com.cajas.model.Ruta;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RutaRepository extends JpaRepository<Ruta, Long> {

    Optional<Ruta> findFirstByUsuarioIdAndEstadoOrderByCreadoEnDesc(
            Long usuarioId,
            EstadoRuta estado
    );

    Optional<Ruta> findByIdAndUsuarioId(
            Long id,
            Long usuarioId
    );

    List<Ruta> findByUsuarioIdOrderByCreadoEnDesc(
            Long usuarioId
    );
}