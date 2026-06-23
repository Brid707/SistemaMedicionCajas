class TotalDiaModel {
  final String inicioDia;
  final String finDia;
  final double totalCajasDia;

  TotalDiaModel({
    required this.inicioDia,
    required this.finDia,
    required this.totalCajasDia,
  });

  factory TotalDiaModel.fromJson(Map<String, dynamic> json) {
    return TotalDiaModel(
      inicioDia: json['inicioDia'] ?? '',
      finDia: json['finDia'] ?? '',
      totalCajasDia: double.tryParse(json['totalCajasDia'].toString()) ?? 0,
    );
  }
}
