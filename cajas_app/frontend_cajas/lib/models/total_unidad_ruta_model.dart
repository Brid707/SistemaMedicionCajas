class TotalUnidadRutaModel {
  final String unidadCodigo;
  final String unidadNombre;
  final double totalCantidad;
  final double totalCajas;

  TotalUnidadRutaModel({
    required this.unidadCodigo,
    required this.unidadNombre,
    required this.totalCantidad,
    required this.totalCajas,
  });

  factory TotalUnidadRutaModel.fromJson(Map<String, dynamic> json) {
    return TotalUnidadRutaModel(
      unidadCodigo: json['unidadCodigo'] ?? '',
      unidadNombre: json['unidadNombre'] ?? '',
      totalCantidad: (json['totalCantidad'] ?? 0).toDouble(),
      totalCajas: (json['totalCajas'] ?? 0).toDouble(),
    );
  }
}
