class UnidadModel {
  final String codigo;
  final String nombre;
  final double equivalente;

  UnidadModel({
    required this.codigo,
    required this.nombre,
    required this.equivalente,
  });

  factory UnidadModel.fromJson(Map<String, dynamic> json) {
    return UnidadModel(
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      equivalente: double.tryParse(json['equivalente'].toString()) ?? 0,
    );
  }
}
