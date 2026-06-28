package com.cajas.service;

import com.cajas.dto.ClienteResponse;
import com.cajas.dto.ConversionResponse;
import com.cajas.dto.RutaResponse;
import com.cajas.dto.TotalUnidadRutaResponse;
import com.cajas.model.Cliente;
import com.cajas.model.Conversion;
import com.cajas.model.EstadoCliente;
import com.cajas.model.EstadoRuta;
import com.cajas.model.Ruta;
import com.cajas.model.Usuario;
import com.cajas.repository.ClienteRepository;
import com.cajas.repository.ConversionRepository;
import com.cajas.repository.RutaRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class RutaService {

    private final RutaRepository rutaRepository;
    private final ClienteRepository clienteRepository;
    private final ConversionRepository conversionRepository;

    public RutaService(
            RutaRepository rutaRepository,
            ClienteRepository clienteRepository,
            ConversionRepository conversionRepository
    ) {
        this.rutaRepository = rutaRepository;
        this.clienteRepository = clienteRepository;
        this.conversionRepository = conversionRepository;
    }

    public RutaResponse crearRutaNueva(Usuario usuario) {
        return rutaRepository
                .findFirstByUsuarioIdAndEstadoOrderByCreadoEnDesc(
                        usuario.getId(),
                        EstadoRuta.ACTIVA
                )
                .map(this::convertirRutaResponse)
                .orElseGet(() -> {
                    Ruta ruta = new Ruta(generarFolioRuta(), usuario);
                    Ruta rutaGuardada = rutaRepository.save(ruta);
                    return convertirRutaResponse(rutaGuardada);
                });
    }

    public RutaResponse obtenerRutaActiva(Usuario usuario) {
        Ruta ruta = rutaRepository
                .findFirstByUsuarioIdAndEstadoOrderByCreadoEnDesc(
                        usuario.getId(),
                        EstadoRuta.ACTIVA
                )
                .orElseThrow(() -> new RuntimeException("No hay ruta activa. Crea una ruta nueva."));

        actualizarTotalRuta(ruta);

        return convertirRutaResponse(ruta);
    }

    public List<RutaResponse> listarRutas(Usuario usuario) {
        return rutaRepository
                .findByUsuarioIdOrderByCreadoEnDesc(usuario.getId())
                .stream()
                .peek(this::actualizarTotalRuta)
                .map(this::convertirRutaResponse)
                .toList();
    }

    public RutaResponse obtenerRutaPorId(Long rutaId, Usuario usuario) {
        Ruta ruta = rutaRepository
                .findByIdAndUsuarioId(rutaId, usuario.getId())
                .orElseThrow(() -> new RuntimeException("Ruta no encontrada para este usuario"));

        actualizarTotalRuta(ruta);

        return convertirRutaResponse(ruta);
    }

    public RutaResponse finalizarRuta(Long rutaId, Usuario usuario) {
        Ruta ruta = rutaRepository
                .findByIdAndUsuarioId(rutaId, usuario.getId())
                .orElseThrow(() -> new RuntimeException("Ruta no encontrada para este usuario"));

        if (ruta.getEstado() == EstadoRuta.FINALIZADA) {
            actualizarTotalRuta(ruta);
            return convertirRutaResponse(ruta);
        }

        List<Cliente> clientes = clienteRepository
                .findByRutaIdAndUsuarioIdOrderByCreadoEnDesc(
                        ruta.getId(),
                        usuario.getId()
                );

        for (Cliente cliente : clientes) {
            if (cliente.getEstado() == EstadoCliente.ACTIVO) {
                cliente.setEstado(EstadoCliente.FINALIZADO);
                cliente.setFinalizadoEn(LocalDateTime.now());
                clienteRepository.save(cliente);
            }
        }

        actualizarTotalRuta(ruta);

        ruta.setEstado(EstadoRuta.FINALIZADA);
        ruta.setFinalizadoEn(LocalDateTime.now());

        Ruta rutaFinalizada = rutaRepository.save(ruta);

        return convertirRutaResponse(rutaFinalizada);
    }

    public List<TotalUnidadRutaResponse> obtenerTotalesPorUnidad(
            Long rutaId,
            Usuario usuario
    ) {
        Ruta ruta = rutaRepository
                .findByIdAndUsuarioId(rutaId, usuario.getId())
                .orElseThrow(() -> new RuntimeException("Ruta no encontrada para este usuario"));

        return calcularTotalesPorUnidad(ruta.getId());
    }

    public void actualizarTotalRuta(Ruta ruta) {
        if (ruta == null || ruta.getId() == null || ruta.getUsuario() == null) {
            return;
        }

        List<Cliente> clientes = clienteRepository
                .findByRutaIdAndUsuarioIdOrderByCreadoEnDesc(
                        ruta.getId(),
                        ruta.getUsuario().getId()
                );

        BigDecimal total = clientes.stream()
                .map(Cliente::getTotalCajas)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        ruta.setTotalCajas(total);
        rutaRepository.save(ruta);
    }

    private RutaResponse convertirRutaResponse(Ruta ruta) {
        List<ClienteResponse> clientes = clienteRepository
                .findByRutaIdAndUsuarioIdOrderByCreadoEnDesc(
                        ruta.getId(),
                        ruta.getUsuario().getId()
                )
                .stream()
                .map(this::convertirClienteResponse)
                .toList();

        List<TotalUnidadRutaResponse> totales = calcularTotalesPorUnidad(ruta.getId());

        return new RutaResponse(
                ruta.getId(),
                ruta.getFolioRuta(),
                ruta.getEstado().name(),
                ruta.getTotalCajas(),
                ruta.getCreadoEn(),
                ruta.getFinalizadoEn(),
                clientes,
                totales
        );
    }

    private List<TotalUnidadRutaResponse> calcularTotalesPorUnidad(Long rutaId) {
        List<Conversion> conversiones = conversionRepository
                .findByCliente_Ruta_IdOrderByCreadoEnAsc(rutaId);

        Map<String, TotalUnidadTemporal> acumulados = new LinkedHashMap<>();

        for (Conversion conversion : conversiones) {
            String codigo = conversion.getUnidadCodigo();

            TotalUnidadTemporal temporal = acumulados.getOrDefault(
                    codigo,
                    new TotalUnidadTemporal(
                            conversion.getUnidadCodigo(),
                            conversion.getUnidadNombre(),
                            BigDecimal.ZERO,
                            BigDecimal.ZERO
                    )
            );

            temporal.totalCantidad = temporal.totalCantidad.add(conversion.getCantidad());
            temporal.totalCajas = temporal.totalCajas.add(conversion.getResultadoCajas());

            acumulados.put(codigo, temporal);
        }

        return acumulados.values()
                .stream()
                .map(item -> new TotalUnidadRutaResponse(
                        item.unidadCodigo,
                        item.unidadNombre,
                        item.totalCantidad,
                        item.totalCajas
                ))
                .toList();
    }

    private ClienteResponse convertirClienteResponse(Cliente cliente) {
        List<ConversionResponse> conversiones = conversionRepository
                .findByClienteIdOrderByCreadoEnAsc(cliente.getId())
                .stream()
                .map(this::convertirConversionResponse)
                .toList();

        return new ClienteResponse(
                cliente.getId(),
                cliente.getFolioCliente(),
                cliente.getEstado().name(),
                cliente.getTotalCajas(),
                cliente.getCreadoEn(),
                cliente.getFinalizadoEn(),
                conversiones
        );
    }

    private ConversionResponse convertirConversionResponse(Conversion conversion) {
        return new ConversionResponse(
                conversion.getId(),
                conversion.getCantidad(),
                conversion.getUnidadCodigo(),
                conversion.getUnidadNombre(),
                conversion.getEquivalente(),
                conversion.getResultadoCajas(),
                conversion.getCreadoEn()
        );
    }

    private String generarFolioRuta() {
        return "RUTA-" + System.currentTimeMillis();
    }

    private static class TotalUnidadTemporal {
        private final String unidadCodigo;
        private final String unidadNombre;
        private BigDecimal totalCantidad;
        private BigDecimal totalCajas;

        private TotalUnidadTemporal(
                String unidadCodigo,
                String unidadNombre,
                BigDecimal totalCantidad,
                BigDecimal totalCajas
        ) {
            this.unidadCodigo = unidadCodigo;
            this.unidadNombre = unidadNombre;
            this.totalCantidad = totalCantidad;
            this.totalCajas = totalCajas;
        }
    }
}