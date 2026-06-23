package com.cajas.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "clientes")
public class Cliente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "folio_cliente", nullable = false, unique = true)
    private String folioCliente;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EstadoCliente estado;

    @Column(name = "total_cajas", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalCajas;

    @Column(name = "creado_en", nullable = false)
    private LocalDateTime creadoEn;

    @Column(name = "finalizado_en")
    private LocalDateTime finalizadoEn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;

    public Cliente() {
    }

    public Cliente(String folioCliente, Usuario usuario) {
        this.folioCliente = folioCliente;
        this.usuario = usuario;
        this.estado = EstadoCliente.ACTIVO;
        this.totalCajas = BigDecimal.ZERO;
        this.creadoEn = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public String getFolioCliente() {
        return folioCliente;
    }

    public void setFolioCliente(String folioCliente) {
        this.folioCliente = folioCliente;
    }

    public EstadoCliente getEstado() {
        return estado;
    }

    public void setEstado(EstadoCliente estado) {
        this.estado = estado;
    }

    public BigDecimal getTotalCajas() {
        return totalCajas;
    }

    public void setTotalCajas(BigDecimal totalCajas) {
        this.totalCajas = totalCajas;
    }

    public LocalDateTime getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(LocalDateTime creadoEn) {
        this.creadoEn = creadoEn;
    }

    public LocalDateTime getFinalizadoEn() {
        return finalizadoEn;
    }

    public void setFinalizadoEn(LocalDateTime finalizadoEn) {
        this.finalizadoEn = finalizadoEn;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}