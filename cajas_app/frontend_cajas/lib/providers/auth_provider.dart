import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_response.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  int? _usuarioId;
  String? _nombre;
  String? _correo;

  bool _cargando = false;
  bool _cargandoSesion = true;

  String? _error;

  String? get token => _token;
  int? get usuarioId => _usuarioId;
  String? get nombre => _nombre;
  String? get correo => _correo;

  bool get cargando => _cargando;
  bool get cargandoSesion => _cargandoSesion;
  bool get estaAutenticado => _token != null && _token!.isNotEmpty;

  String? get error => _error;

  Future<void> cargarSesion() async {
    try {
      _token = await _storage.read(key: 'token');
      _nombre = await _storage.read(key: 'nombre');
      _correo = await _storage.read(key: 'correo');

      final usuarioIdString = await _storage.read(key: 'usuarioId');
      if (usuarioIdString != null) {
        _usuarioId = int.tryParse(usuarioIdString);
      }
    } finally {
      _cargandoSesion = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String correo, required String password}) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final AuthResponse response = await _apiService.login(
        correo: correo,
        password: password,
      );

      await _guardarSesion(response);

      _cargando = false;
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _cargando = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> register({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final AuthResponse response = await _apiService.register(
        nombre: nombre,
        correo: correo,
        password: password,
      );

      await _guardarSesion(response);

      _cargando = false;
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _cargando = false;
      notifyListeners();

      return false;
    }
  }

  Future<void> _guardarSesion(AuthResponse response) async {
    _token = response.token;
    _usuarioId = response.usuarioId;
    _nombre = response.nombre;
    _correo = response.correo;

    await _storage.write(key: 'token', value: response.token);
    await _storage.write(
      key: 'usuarioId',
      value: response.usuarioId.toString(),
    );
    await _storage.write(key: 'nombre', value: response.nombre);
    await _storage.write(key: 'correo', value: response.correo);
  }

  Future<void> cerrarSesion() async {
    _token = null;
    _usuarioId = null;
    _nombre = null;
    _correo = null;
    _error = null;

    await _storage.deleteAll();

    notifyListeners();
  }
}
