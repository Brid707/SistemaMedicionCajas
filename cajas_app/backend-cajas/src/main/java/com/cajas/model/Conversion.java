package com.cajas.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "conversiones")
public class Conversion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal cantidad;

    @Column(name = "unidad_codigo", nullable = false)
    private String unidadCodigo;

    @Column(name = "unidad_nombre", nullable = false)
    private String unidadNombre;

    @Column(name = "equivalente", nullable = false, precision = 12, scale = 2)
    private BigDecimal equivalente;

    @Column(name = "resultado_cajas", nullable = false, precision = 12, scale = 2)
    private BigDecimal resultadoCajas;

    @Column(name = "creado_en", nullable = false)
    private LocalDateTime creadoEn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cliente_id", nullable = false)
    private Cliente cliente;

    public Conversion() {
    }

    public Conversion(
            BigDecimal cantidad,
            String unidadCodigo,
            String unidadNombre,
            BigDecimal equivalente,
            BigDecimal resultadoCajas,
            Cliente cliente
    ) {
        this.cantidad = cantidad;
        this.unidadCodigo = unidadCodigo;
        this.unidadNombre = unidadNombre;
        this.equivalente = equivalente;
        this.resultadoCajas = resultadoCajas;
        this.cliente = cliente;
        this.creadoEn = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public BigDecimal getCantidad() {
        return cantidad;
    }

    public String getUnidadCodigo() {
        return unidadCodigo;
    }

    public String getUnidadNombre() {
        return unidadNombre;
    }

    public BigDecimal getEquivalente() {
        return equivalente;
    }

    public BigDecimal getResultadoCajas() {
        return resultadoCajas;
    }

    public LocalDateTime getCreadoEn() {
        return creadoEn;
    }

    public Cliente getCliente() {
        return cliente;
    }
}
