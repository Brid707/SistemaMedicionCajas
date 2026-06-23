import 'package:flutter/material.dart';

import '../models/cliente_model.dart';
import '../models/total_dia_model.dart';
import '../models/unidad_model.dart';
import '../services/api_service.dart';

class CalculoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<UnidadModel> unidades = [];
  List<ClienteModel> historial = [];

  ClienteModel? clienteActivo;
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

      cargando = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> crearNuevoCliente(String token) async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      clienteActivo = await _apiService.crearClienteNuevo(token);

      fechaHistorialSeleccionada = DateTime.now();

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
    if (clienteActivo == null) {
      error = 'Primero presiona Nuevo';
      notifyListeners();
      return;
    }

    cargando = true;
    error = null;
    notifyListeners();

    try {
      clienteActivo = await _apiService.agregarConversion(
        token: token,
        clienteId: clienteActivo!.id,
        cantidad: cantidad,
        unidadCodigo: unidadCodigo,
      );

      fechaHistorialSeleccionada = DateTime.now();

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
      clienteActivo = await _apiService.finalizarCliente(
        token: token,
        clienteId: clienteActivo!.id,
      );

      fechaHistorialSeleccionada = DateTime.now();

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
  }

  void limpiarError() {
    error = null;
    notifyListeners();
  }
}
