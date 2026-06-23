package com.cajas.unidad;

import java.math.BigDecimal;

public enum TipoUnidad implements Unidad {

    BALON("Balón", "1"),
    BOLSAS("Bolsas", "6"),
    BULTO("Bulto", "1"),
    CUBETA("Cubeta", "1"),
    CAJAS("Cajas", "1"),
    EMPLAYE("Emplaye", "1"),
    EXHIBIDORES("Exhibidores", "10"),
    MEDIA_CAJA("1/2 caja", "2"),
    FARDO("Fardo", "1"),
    KILOS("Kilos", "10"),
    PAQUETES_MENOR_4KG("Paquetes < 4kg", "6"),
    PAQUETES_ENTRE_4_Y_7KG("Paquetes > 4kg y < 7kg", "2"),
    PAQUETES_MAYOR_7KG("Paquetes > 7kg", "1"),
    PIEZAS("Piezas", "12"),
    ROLLO("Rollo", "4"),
    SACO("Saco", "1"),
    SIX("Six", "4"),
    TIRAS("Tiras", "6"),
    VITROLEROS("Vitroleros", "6");

    private final String nombre;
    private final BigDecimal equivalente;

    TipoUnidad(String nombre, String equivalente) {
        this.nombre = nombre;
        this.equivalente = new BigDecimal(equivalente);
    }

    @Override
    public String getNombre() {
        return nombre;
    }

    @Override
    public BigDecimal getEquivalente() {
        return equivalente;
    }
}
