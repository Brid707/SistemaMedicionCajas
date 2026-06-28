import 'cliente_model.dart';
import 'total_unidad_ruta_model.dart';

class RutaModel {
  final int id;
  final String folioRuta;
  final String estado;
  final double totalCajas;
  final String creadoEn;
  final String? finalizadoEn;
  final List<ClienteModel> clientes;
  final List<TotalUnidadRutaModel> totalesPorUnidad;

  RutaModel({
    required this.id,
    required this.folioRuta,
    required this.estado,
    required this.totalCajas,
    required this.creadoEn,
    required this.finalizadoEn,
    required this.clientes,
    required this.totalesPorUnidad,
  });

  factory RutaModel.fromJson(Map<String, dynamic> json) {
    return RutaModel(
      id: json['id'] ?? 0,
      folioRuta: json['folioRuta'] ?? '',
      estado: json['estado'] ?? '',
      totalCajas: (json['totalCajas'] ?? 0).toDouble(),
      creadoEn: json['creadoEn'] ?? '',
      finalizadoEn: json['finalizadoEn'],
      clientes: ((json['clientes'] ?? []) as List)
          .map((item) => ClienteModel.fromJson(item))
          .toList(),
      totalesPorUnidad: ((json['totalesPorUnidad'] ?? []) as List)
          .map((item) => TotalUnidadRutaModel.fromJson(item))
          .toList(),
    );
  }

  bool get estaActiva => estado == 'ACTIVA';
  bool get estaFinalizada => estado == 'FINALIZADA';
}
