package com.cajas.repository;

import com.cajas.model.Cliente;
import com.cajas.model.EstadoCliente;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ClienteRepository extends JpaRepository<Cliente, Long> {

    Optional<Cliente> findFirstByUsuarioIdAndEstadoOrderByCreadoEnDesc(
            Long usuarioId,
            EstadoCliente estado
    );

    Optional<Cliente> findFirstByUsuarioIdAndRutaIdAndEstadoOrderByCreadoEnDesc(
            Long usuarioId,
            Long rutaId,
            EstadoCliente estado
    );

    Optional<Cliente> findByIdAndUsuarioId(
            Long id,
            Long usuarioId
    );

    List<Cliente> findByUsuarioIdAndCreadoEnAfterOrderByCreadoEnDesc(
            Long usuarioId,
            LocalDateTime creadoEn
    );

    List<Cliente> findByUsuarioIdAndCreadoEnBetweenOrderByCreadoEnDesc(
            Long usuarioId,
            LocalDateTime inicio,
            LocalDateTime fin
    );

    List<Cliente> findByRutaIdAndUsuarioIdOrderByCreadoEnDesc(
            Long rutaId,
            Long usuarioId
    );
}