import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_response.dart';
import '../models/cliente_model.dart';
import '../models/ruta_model.dart';
import '../models/total_dia_model.dart';
import '../models/unidad_model.dart';

class ApiService {
  static const String baseUrl = 'https://sistemamedicioncajas.onrender.com/api';

  Future<AuthResponse> login({
    required String correo,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No se pudo iniciar sesión');
  }

  Future<AuthResponse> register({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'correo': correo,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No se pudo registrar el usuario');
  }

  Future<Map<String, dynamic>> obtenerUsuarioActual(String token) async {
    final url = Uri.parse('$baseUrl/auth/me');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['message'] ?? 'Sesión no válida');
  }

  Future<List<UnidadModel>> obtenerUnidades() async {
    final url = Uri.parse('$baseUrl/unidades');

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data as List).map((item) => UnidadModel.fromJson(item)).toList();
    }

    throw Exception('No se pudieron cargar las unidades');
  }

  Future<RutaModel> crearRutaNueva(String token) async {
    final url = Uri.parse('$baseUrl/rutas/nueva');

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RutaModel.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No se pudo crear la ruta');
  }

  Future<RutaModel> obtenerRutaActiva(String token) async {
    final url = Uri.parse('$baseUrl/rutas/activa');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RutaModel.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No hay ruta activa');
  }

  Future<RutaModel> finalizarRuta({
    required String token,
    required int rutaId,
  }) async {
    final url = Uri.parse('$baseUrl/rutas/$rutaId/finalizar');

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RutaModel.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No se pudo finalizar la ruta');
  }

  Future<List<RutaModel>> obtenerRutas(String token) async {
    final url = Uri.parse('$baseUrl/rutas');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data as List).map((item) => RutaModel.fromJson(item)).toList();
    }

    throw Exception(data['message'] ?? 'No se pudieron cargar las rutas');
  }

  Future<ClienteModel> crearClienteNuevo(String token) async {
    final url = Uri.parse('$baseUrl/clientes/nuevo');

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ClienteModel.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No se pudo crear cliente');
  }

  Future<ClienteModel> obtenerClienteActivo(String token) async {
    final url = Uri.parse('$baseUrl/clientes/activo');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ClienteModel.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No hay cliente activo');
  }

  Future<ClienteModel> agregarConversion({
    required String token,
    required int clienteId,
    required double cantidad,
    required String unidadCodigo,
  }) async {
    final url = Uri.parse('$baseUrl/clientes/$clienteId/conversiones');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'cantidad': cantidad, 'unidadCodigo': unidadCodigo}),
    );

    final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode == 200) {
      return ClienteModel.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No se pudo agregar la conversión');
  }

  Future<ClienteModel> finalizarCliente({
    required String token,
    required int clienteId,
  }) async {
    final url = Uri.parse('$baseUrl/clientes/$clienteId/finalizar');

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ClienteModel.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No se pudo finalizar cliente');
  }

  Future<List<ClienteModel>> obtenerHistorial(String token) async {
    final url = Uri.parse('$baseUrl/historial');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data as List).map((item) => ClienteModel.fromJson(item)).toList();
    }

    throw Exception(data['message'] ?? 'No se pudo cargar historial');
  }

  Future<TotalDiaModel> obtenerTotalDiaPorFecha({
    required String token,
    required DateTime fecha,
  }) async {
    final fechaApi = _formatearFechaParaApi(fecha);

    final url = Uri.parse('$baseUrl/historial/dia?fecha=$fechaApi');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return TotalDiaModel.fromJson(data);
    }

    throw Exception(data['message'] ?? 'No se pudo cargar total de la fecha');
  }

  Future<List<ClienteModel>> obtenerHistorialPorFecha({
    required String token,
    required DateTime fecha,
  }) async {
    final fechaApi = _formatearFechaParaApi(fecha);

    final url = Uri.parse('$baseUrl/historial/fecha?fecha=$fechaApi');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data as List).map((item) => ClienteModel.fromJson(item)).toList();
    }

    throw Exception(
      data['message'] ?? 'No se pudo cargar historial de la fecha',
    );
  }

  String _formatearFechaParaApi(DateTime fecha) {
    final year = fecha.year.toString().padLeft(4, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final day = fecha.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
