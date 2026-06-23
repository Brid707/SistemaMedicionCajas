class AuthResponse {
  final String token;
  final int usuarioId;
  final String nombre;
  final String correo;

  AuthResponse({
    required this.token,
    required this.usuarioId,
    required this.nombre,
    required this.correo,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      usuarioId: json['usuarioId'] ?? 0,
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
    );
  }
}
