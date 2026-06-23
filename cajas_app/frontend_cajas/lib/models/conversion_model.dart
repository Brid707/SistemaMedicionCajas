class ConversionModel {
  final int id;
  final double cantidad;
  final String unidadCodigo;
  final String unidadNombre;
  final double equivalente;
  final double resultadoCajas;
  final String creadoEn;

  ConversionModel({
    required this.id,
    required this.cantidad,
    required this.unidadCodigo,
    required this.unidadNombre,
    required this.equivalente,
    required this.resultadoCajas,
    required this.creadoEn,
  });

  factory ConversionModel.fromJson(Map<String, dynamic> json) {
    return ConversionModel(
      id: json['id'] ?? 0,
      cantidad: double.tryParse(json['cantidad'].toString()) ?? 0,
      unidadCodigo: json['unidadCodigo'] ?? '',
      unidadNombre: json['unidadNombre'] ?? '',
      equivalente: double.tryParse(json['equivalente'].toString()) ?? 0,
      resultadoCajas: double.tryParse(json['resultadoCajas'].toString()) ?? 0,
      creadoEn: json['creadoEn'] ?? '',
    );
  }
}
