import 'conversion_model.dart';

class ClienteModel {
  final int id;
  final String folioCliente;
  final String estado;
  final double totalCajas;
  final String creadoEn;
  final String? finalizadoEn;
  final List<ConversionModel> conversiones;

  ClienteModel({
    required this.id,
    required this.folioCliente,
    required this.estado,
    required this.totalCajas,
    required this.creadoEn,
    required this.finalizadoEn,
    required this.conversiones,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    final conversionesJson = json['conversiones'] as List? ?? [];

    return ClienteModel(
      id: json['id'] ?? 0,
      folioCliente: json['folioCliente'] ?? '',
      estado: json['estado'] ?? '',
      totalCajas: double.tryParse(json['totalCajas'].toString()) ?? 0,
      creadoEn: json['creadoEn'] ?? '',
      finalizadoEn: json['finalizadoEn'],
      conversiones: conversionesJson
          .map((item) => ConversionModel.fromJson(item))
          .toList(),
    );
  }
}
