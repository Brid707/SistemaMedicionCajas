package com.cajas.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "rutas")
public class Ruta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "folio_ruta", nullable = false, unique = true)
    private String folioRuta;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EstadoRuta estado = EstadoRuta.ACTIVA;

    @Column(name = "total_cajas", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalCajas = BigDecimal.ZERO;

    @Column(name = "creado_en", nullable = false)
    private LocalDateTime creadoEn = LocalDateTime.now();

    @Column(name = "finalizado_en")
    private LocalDateTime finalizadoEn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    public Ruta() {
    }

    public Ruta(String folioRuta, Usuario usuario) {
        this.folioRuta = folioRuta;
        this.usuario = usuario;
        this.estado = EstadoRuta.ACTIVA;
        this.totalCajas = BigDecimal.ZERO;
        this.creadoEn = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public String getFolioRuta() {
        return folioRuta;
    }

    public void setFolioRuta(String folioRuta) {
        this.folioRuta = folioRuta;
    }

    public EstadoRuta getEstado() {
        return estado;
    }

    public void setEstado(EstadoRuta estado) {
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