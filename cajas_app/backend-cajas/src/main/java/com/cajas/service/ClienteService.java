package com.cajas.service;

import com.cajas.dto.ClienteResponse;
import com.cajas.dto.ConversionRequest;
import com.cajas.dto.ConversionResponse;
import com.cajas.dto.TotalDiaResponse;
import com.cajas.model.Cliente;
import com.cajas.model.Conversion;
import com.cajas.model.EstadoCliente;
import com.cajas.model.Usuario;
import com.cajas.repository.ClienteRepository;
import com.cajas.repository.ConversionRepository;
import com.cajas.unidad.TipoUnidad;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Service
public class ClienteService {

    private final ClienteRepository clienteRepository;
    private final ConversionRepository conversionRepository;

    public ClienteService(
            ClienteRepository clienteRepository,
            ConversionRepository conversionRepository
    ) {
        this.clienteRepository = clienteRepository;
        this.conversionRepository = conversionRepository;
    }

    public ClienteResponse crearNuevoCliente(Usuario usuario) {
        String folio = generarFolioCliente();

        Cliente cliente = new Cliente(folio, usuario);

        Cliente clienteGuardado = clienteRepository.save(cliente);

        return convertirClienteResponse(clienteGuardado);
    }

    public ClienteResponse obtenerClienteActivo(Usuario usuario) {
        Cliente cliente = clienteRepository
                .findFirstByUsuarioIdAndEstadoOrderByCreadoEnDesc(
                        usuario.getId(),
                        EstadoCliente.ACTIVO
                )
                .orElseThrow(() -> new RuntimeException("No hay cliente activo. Presiona el botón Nueva."));

        return convertirClienteResponse(cliente);
    }

    public ClienteResponse agregarConversion(
            Long clienteId,
            ConversionRequest request,
            Usuario usuario
    ) {
        Cliente cliente = clienteRepository.findByIdAndUsuarioId(clienteId, usuario.getId())
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado para este usuario"));

        if (cliente.getEstado() == EstadoCliente.FINALIZADO) {
            throw new RuntimeException("Este cliente ya fue finalizado. Crea uno nuevo.");
        }

        TipoUnidad unidad = buscarUnidad(request.unidadCodigo());

        BigDecimal resultadoCajas = request.cantidad()
                .divide(unidad.getEquivalente(), 2, RoundingMode.HALF_UP);

        Conversion conversion = new Conversion(
                request.cantidad(),
                unidad.name(),
                unidad.getNombre(),
                unidad.getEquivalente(),
                resultadoCajas,
                cliente
        );

        conversionRepository.save(conversion);

        BigDecimal nuevoTotal = cliente.getTotalCajas().add(resultadoCajas);
        cliente.setTotalCajas(nuevoTotal);

        Cliente clienteActualizado = clienteRepository.save(cliente);

        return convertirClienteResponse(clienteActualizado);
    }

    public ClienteResponse finalizarCliente(Long clienteId, Usuario usuario) {
        Cliente cliente = clienteRepository.findByIdAndUsuarioId(clienteId, usuario.getId())
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado para este usuario"));

        if (cliente.getEstado() == EstadoCliente.FINALIZADO) {
            return convertirClienteResponse(cliente);
        }

        cliente.setEstado(EstadoCliente.FINALIZADO);
        cliente.setFinalizadoEn(LocalDateTime.now());

        Cliente clienteFinalizado = clienteRepository.save(cliente);

        return convertirClienteResponse(clienteFinalizado);
    }

    public List<ClienteResponse> obtenerHistorial48Horas(Usuario usuario) {
        LocalDateTime hace48Horas = LocalDateTime.now().minusHours(48);

        return clienteRepository
                .findByUsuarioIdAndCreadoEnAfterOrderByCreadoEnDesc(
                        usuario.getId(),
                        hace48Horas
                )
                .stream()
                .map(this::convertirClienteResponse)
                .toList();
    }

    public TotalDiaResponse obtenerTotalDelDia(Usuario usuario) {
        return obtenerTotalPorFecha(usuario, LocalDate.now());
    }

    public TotalDiaResponse obtenerTotalPorFecha(Usuario usuario, LocalDate fecha) {
        LocalDateTime inicioDia = fecha.atStartOfDay();
        LocalDateTime finDia = fecha.atTime(23, 59, 59);

        List<Cliente> clientesDelDia = clienteRepository
                .findByUsuarioIdAndCreadoEnBetweenOrderByCreadoEnDesc(
                        usuario.getId(),
                        inicioDia,
                        finDia
                );

        BigDecimal total = clientesDelDia.stream()
                .map(Cliente::getTotalCajas)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return new TotalDiaResponse(inicioDia, finDia, total);
    }

    public List<ClienteResponse> obtenerHistorialPorFecha(Usuario usuario, LocalDate fecha) {
        LocalDateTime inicioDia = fecha.atStartOfDay();
        LocalDateTime finDia = fecha.atTime(23, 59, 59);

        return clienteRepository
                .findByUsuarioIdAndCreadoEnBetweenOrderByCreadoEnDesc(
                        usuario.getId(),
                        inicioDia,
                        finDia
                )
                .stream()
                .map(this::convertirClienteResponse)
                .toList();
    }

    public ClienteResponse obtenerClientePorId(Long clienteId, Usuario usuario) {
        Cliente cliente = clienteRepository.findByIdAndUsuarioId(clienteId, usuario.getId())
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado para este usuario"));

        return convertirClienteResponse(cliente);
    }

    private TipoUnidad buscarUnidad(String unidadCodigo) {
        return Arrays.stream(TipoUnidad.values())
                .filter(unidad -> unidad.name().equalsIgnoreCase(unidadCodigo))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Unidad no válida: " + unidadCodigo));
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

    private String generarFolioCliente() {
        return "CLI-" + System.currentTimeMillis();
    }
}