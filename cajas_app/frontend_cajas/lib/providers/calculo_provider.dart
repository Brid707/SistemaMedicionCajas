import 'package:flutter/material.dart';

import '../models/cliente_model.dart';
import '../models/ruta_model.dart';
import '../models/total_dia_model.dart';
import '../models/unidad_model.dart';
import '../services/api_service.dart';

class CalculoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<UnidadModel> unidades = [];
  List<ClienteModel> historial = [];
  List<RutaModel> rutas = [];

  ClienteModel? clienteActivo;
  RutaModel? rutaActiva;
  TotalDiaModel? totalDia;

  DateTime fechaHistorialSeleccionada = DateTime.now();

  bool cargando = false;
  String? error;

  Future<void> cargarDatosIniciales(String token) async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      unidades = await _apiService.obtenerUnidades();

      totalDia = await _apiService.obtenerTotalDiaPorFecha(
        token: token,
        fecha: fechaHistorialSeleccionada,
      );

      historial = await _apiService.obtenerHistorialPorFecha(
        token: token,
        fecha: fechaHistorialSeleccionada,
      );

      rutas = await _apiService.obtenerRutas(token);

      try {
        rutaActiva = await _apiService.obtenerRutaActiva(token);
      } catch (_) {
        rutaActiva = null;
      }

      try {
        clienteActivo = await _apiService.obtenerClienteActivo(token);
      } catch (_) {
        clienteActivo = null;
      }

      cargando = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarHistorialPorFecha({
    required String token,
    required DateTime fecha,
  }) async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      fechaHistorialSeleccionada = fecha;

      totalDia = await _apiService.obtenerTotalDiaPorFecha(
        token: token,
        fecha: fecha,
      );

      historial = await _apiService.obtenerHistorialPorFecha(
        token: token,
        fecha: fecha,
      );

      rutas = await _apiService.obtenerRutas(token);

      try {
        rutaActiva = await _apiService.obtenerRutaActiva(token);
      } catch (_) {
        rutaActiva = null;
      }

      try {
        clienteActivo = await _apiService.obtenerClienteActivo(token);
      } catch (_) {
        clienteActivo = null;
      }

      cargando = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> crearRutaNueva(String token) async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      fechaHistorialSeleccionada = DateTime.now();

      rutaActiva = await _apiService.crearRutaNueva(token);
      rutas = await _apiService.obtenerRutas(token);

      clienteActivo = null;

      await _recargarResumen(token);

      cargando = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> finalizarRuta(String token) async {
    if (rutaActiva == null) {
      error = 'No hay ruta activa';
      notifyListeners();
      return;
    }

    cargando = true;
    error = null;
    notifyListeners();

    try {
      fechaHistorialSeleccionada = DateTime.now();

      await _apiService.finalizarRuta(token: token, rutaId: rutaActiva!.id);

      rutaActiva = null;
      clienteActivo = null;

      await _recargarResumen(token);

      cargando = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> crearNuevoCliente(String token) async {
    if (rutaActiva == null) {
      error = 'Primero crea una ruta';
      notifyListeners();
      return;
    }

    cargando = true;
    error = null;
    notifyListeners();

    try {
      fechaHistorialSeleccionada = DateTime.now();

      clienteActivo = await _apiService.crearClienteNuevo(token);

      await _recargarResumen(token);

      cargando = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> agregarConversion({
    required String token,
    required double cantidad,
    required String unidadCodigo,
  }) async {
    if (rutaActiva == null) {
      error = 'Primero crea una ruta';
      notifyListeners();
      return;
    }

    if (clienteActivo == null) {
      error = 'Primero presiona Nueva para crear cliente';
      notifyListeners();
      return;
    }

    cargando = true;
    error = null;
    notifyListeners();

    try {
      fechaHistorialSeleccionada = DateTime.now();

      clienteActivo = await _apiService.agregarConversion(
        token: token,
        clienteId: clienteActivo!.id,
        cantidad: cantidad,
        unidadCodigo: unidadCodigo,
      );

      await _recargarResumen(token);

      cargando = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> finalizarCliente(String token) async {
    if (clienteActivo == null) {
      error = 'No hay cliente activo';
      notifyListeners();
      return;
    }

    cargando = true;
    error = null;
    notifyListeners();

    try {
      fechaHistorialSeleccionada = DateTime.now();

      clienteActivo = await _apiService.finalizarCliente(
        token: token,
        clienteId: clienteActivo!.id,
      );

      await _recargarResumen(token);

      clienteActivo = null;

      cargando = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> _recargarResumen(String token) async {
    totalDia = await _apiService.obtenerTotalDiaPorFecha(
      token: token,
      fecha: fechaHistorialSeleccionada,
    );

    historial = await _apiService.obtenerHistorialPorFecha(
      token: token,
      fecha: fechaHistorialSeleccionada,
    );

    rutas = await _apiService.obtenerRutas(token);

    try {
      rutaActiva = await _apiService.obtenerRutaActiva(token);
    } catch (_) {
      rutaActiva = null;
    }

    try {
      clienteActivo = await _apiService.obtenerClienteActivo(token);
    } catch (_) {
      clienteActivo = null;
    }
  }

  void limpiarError() {
    error = null;
    notifyListeners();
  }
}
