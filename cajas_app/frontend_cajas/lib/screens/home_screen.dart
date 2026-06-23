import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../models/unidad_model.dart';
import '../providers/auth_provider.dart';
import '../providers/calculo_provider.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_dark_button.dart';
import '../widgets/app_header.dart';
import '../widgets/dark_box.dart';
import 'cliente_detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum PantallaActual { home, calculo, historial }

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController cantidadController = TextEditingController();

  UnidadModel? unidadSeleccionada;
  PantallaActual pantallaActual = PantallaActual.home;

  bool datosCargados = false;

  @override
  void initState() {
    super.initState();

    cantidadController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cargarDatosIniciales();
    });
  }

  @override
  void dispose() {
    cantidadController.dispose();
    super.dispose();
  }

  Future<void> cargarDatosIniciales() async {
    final auth = context.read<AuthProvider>();
    final calculo = context.read<CalculoProvider>();

    if (auth.token == null) return;

    await calculo.cargarDatosIniciales(auth.token!);

    if (!mounted) return;

    if (calculo.unidades.isNotEmpty) {
      setState(() {
        unidadSeleccionada = calculo.unidades.first;
        datosCargados = true;
      });
    } else {
      setState(() {
        datosCargados = true;
      });
    }
  }

  Future<void> recargarAlCambiarPantalla() async {
    final auth = context.read<AuthProvider>();
    final calculo = context.read<CalculoProvider>();

    if (auth.token == null) return;

    if (pantallaActual == PantallaActual.historial) {
      await calculo.cargarHistorialPorFecha(
        token: auth.token!,
        fecha: calculo.fechaHistorialSeleccionada,
      );
    } else {
      await calculo.cargarDatosIniciales(auth.token!);
    }

    if (!mounted) return;

    if (unidadSeleccionada == null && calculo.unidades.isNotEmpty) {
      setState(() {
        unidadSeleccionada = calculo.unidades.first;
      });
    }
  }

  double get cantidad {
    return double.tryParse(cantidadController.text.trim()) ?? 0;
  }

  double get resultadoPreview {
    if (cantidad <= 0 || unidadSeleccionada == null) return 0;
    return cantidad / unidadSeleccionada!.equivalente;
  }

  int get currentIndex {
    switch (pantallaActual) {
      case PantallaActual.home:
        return 0;
      case PantallaActual.calculo:
        return 1;
      case PantallaActual.historial:
        return 2;
    }
  }

  Future<void> crearNuevoCliente() async {
    final auth = context.read<AuthProvider>();
    final calculo = context.read<CalculoProvider>();

    if (auth.token == null) return;

    await calculo.crearNuevoCliente(auth.token!);

    if (!mounted) return;

    if (calculo.error != null) {
      mostrarMensaje(calculo.error!);
      return;
    }

    cantidadController.clear();
    mostrarMensaje('Cliente nuevo creado. Ya puedes capturar datos.');
  }

  Future<void> guardarConversion() async {
    final auth = context.read<AuthProvider>();
    final calculo = context.read<CalculoProvider>();

    if (auth.token == null) return;

    if (calculo.clienteActivo == null) {
      mostrarMensaje('Primero presiona NUEVA');
      return;
    }

    if (cantidad <= 0) {
      mostrarMensaje('Ingresa una cantidad válida');
      return;
    }

    if (unidadSeleccionada == null) {
      mostrarMensaje('Selecciona una unidad');
      return;
    }

    await calculo.agregarConversion(
      token: auth.token!,
      cantidad: cantidad,
      unidadCodigo: unidadSeleccionada!.codigo,
    );

    if (!mounted) return;

    if (calculo.error != null) {
      mostrarMensaje(calculo.error!);
      return;
    }

    cantidadController.clear();
    mostrarMensaje('Conversión guardada');
  }

  Future<void> finalizarCliente() async {
    final auth = context.read<AuthProvider>();
    final calculo = context.read<CalculoProvider>();

    if (auth.token == null) return;

    if (calculo.clienteActivo == null) {
      mostrarMensaje('No hay cliente activo');
      return;
    }

    await calculo.finalizarCliente(auth.token!);

    if (!mounted) return;

    if (calculo.error != null) {
      mostrarMensaje(calculo.error!);
      return;
    }

    cantidadController.clear();
    mostrarMensaje('Cliente finalizado. Campos bloqueados.');
  }

  Future<void> seleccionarFechaHistorial() async {
    final auth = context.read<AuthProvider>();
    final calculo = context.read<CalculoProvider>();

    if (auth.token == null) return;

    final fechaElegida = await showDatePicker(
      context: context,
      initialDate: calculo.fechaHistorialSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Selecciona el día',
      confirmText: 'Aceptar',
      cancelText: 'Cancelar',
    );

    if (fechaElegida == null) return;

    await calculo.cargarHistorialPorFecha(
      token: auth.token!,
      fecha: fechaElegida,
    );

    if (!mounted) return;

    if (calculo.error != null) {
      mostrarMensaje(calculo.error!);
      return;
    }

    mostrarMensaje('Total actualizado para ${formatearFecha(fechaElegida)}');
  }

  Future<void> cerrarSesion() async {
    final auth = context.read<AuthProvider>();

    await auth.cerrarSesion();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  void cambiarPantalla(int index) {
    setState(() {
      if (index == 0) pantallaActual = PantallaActual.home;
      if (index == 1) pantallaActual = PantallaActual.calculo;
      if (index == 2) pantallaActual = PantallaActual.historial;
    });

    recargarAlCambiarPantalla();
  }

  @override
  Widget build(BuildContext context) {
    final calculo = context.watch<CalculoProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: calculo.cargando && !datosCargados
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(child: _contenido(calculo)),
                  Positioned(
                    right: 20,
                    top: 12,
                    child: IconButton(
                      onPressed: cerrarSesion,
                      icon: const Icon(Icons.logout),
                    ),
                  ),
                  Positioned(
                    left: 42,
                    right: 42,
                    bottom: 18,
                    child: AppBottomNav(
                      currentIndex: currentIndex,
                      onTap: cambiarPantalla,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _contenido(CalculoProvider calculo) {
    switch (pantallaActual) {
      case PantallaActual.home:
        return _pantallaHome(calculo);
      case PantallaActual.calculo:
        return _pantallaCalculo(calculo);
      case PantallaActual.historial:
        return _pantallaHistorial(calculo);
    }
  }

  Widget _pantallaHome(CalculoProvider calculo) {
    final bool clienteActivo = calculo.clienteActivo != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(
            titulo: '¡Bienvenido!',
            subtitulo: 'SISTEMA MEDICION DE\nCAJAS',
          ),

          Padding(
            padding: const EdgeInsets.only(left: 37, top: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppDarkButton(
                text: clienteActivo ? 'ACTIVO' : 'NUEVA',
                onPressed: calculo.cargando || clienteActivo
                    ? null
                    : crearNuevoCliente,
                width: 118,
                height: 42,
              ),
            ),
          ),

          const SizedBox(height: 12),

          if (!clienteActivo)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Text(
                'Presiona NUEVA para iniciar un cliente y activar los campos.',
                textAlign: TextAlign.center,
                style: AppTextStyles.normal.copyWith(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          const SizedBox(height: 12),

          _textoCentro('Ingrese la cantidad de que\ndesee convertir a cajas'),
          const SizedBox(height: 22),
          _filaCantidad(clienteActivo),
          const SizedBox(height: 28),
          _textoCentro('Despliegue y elija la conversion'),
          const SizedBox(height: 22),
          _filaUnidad(calculo, clienteActivo),
          const SizedBox(height: 28),
          _textoCentro('Resultado en cajas'),
          const SizedBox(height: 22),
          _filaResultado(clienteActivo),
          const SizedBox(height: 34),
          _botonesHome(calculo, clienteActivo),
        ],
      ),
    );
  }

  Widget _pantallaCalculo(CalculoProvider calculo) {
    final cliente = calculo.clienteActivo;
    final conversiones = cliente?.conversiones ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(
            titulo: 'Total',
            subtitulo: 'CAJAS DE LA\nSOLICITUD ACTUAL',
          ),
          const SizedBox(height: 56),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 58),
            child: Column(
              children: [
                if (conversiones.isEmpty)
                  Text('Aún no hay conversiones.', style: AppTextStyles.label)
                else
                  ...conversiones.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.unidadNombre.toUpperCase()} TOTAL:',
                              style: AppTextStyles.label,
                            ),
                          ),
                          Text(
                            '${item.resultadoCajas.toStringAsFixed(2)} CAJAS',
                            style: AppTextStyles.label,
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(height: 260),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 58),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'TOTAL DE CAJAS\nPOR CLIENTE:',
                    style: AppTextStyles.label,
                  ),
                ),
                Text(
                  '${(cliente?.totalCajas ?? 0).toStringAsFixed(2)} CAJAS',
                  style: AppTextStyles.label,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pantallaHistorial(CalculoProvider calculo) {
    final historial = calculo.historial;
    final totalDia = calculo.totalDia?.totalCajasDia ?? 0;
    final fecha = calculo.fechaHistorialSeleccionada;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(titulo: 'Historial', subtitulo: 'TOTAL DE CONSULTAS'),
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 55),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: calculo.cargando ? null : seleccionarFechaHistorial,
              child: Container(
                constraints: const BoxConstraints(minHeight: 58),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'TOTAL DE CAJAS\n${formatearFecha(fecha)}: ${totalDia.toStringAsFixed(2)}',
                    style: AppTextStyles.button.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el recuadro para elegir otra fecha',
            textAlign: TextAlign.center,
            style: AppTextStyles.normal.copyWith(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text('Historial:', style: AppTextStyles.sectionTitle),
          ),
          const SizedBox(height: 14),
          if (historial.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Text(
                'No hay registros para esta fecha.',
                style: AppTextStyles.normal,
              ),
            )
          else
            ...historial.map((cliente) {
              return Padding(
                padding: const EdgeInsets.only(left: 43, right: 37, bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClienteDetalleScreen(cliente: cliente),
                      ),
                    ).then((_) {
                      recargarAlCambiarPantalla();
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: DarkBox(
                          height: 68,
                          child: Center(
                            child: Text(
                              'CLIENTE ${cliente.id}\n${cliente.totalCajas.toStringAsFixed(2)} CAJAS',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.button,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: 82,
                        child: Text(
                          'hora ${_hora(cliente.creadoEn)}',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.label,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _textoCentro(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: AppTextStyles.sectionTitle,
      ),
    );
  }

  Widget _campoBloqueado({required bool activo, required Widget child}) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: activo ? AppColors.inputDark : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _filaCantidad(bool activo) {
    return Padding(
      padding: const EdgeInsets.only(left: 43, right: 39),
      child: Row(
        children: [
          Expanded(
            child: _campoBloqueado(
              activo: activo,
              child: TextField(
                controller: cantidadController,
                enabled: activo,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: activo ? '' : 'Bloqueado',
                  hintStyle: AppTextStyles.button.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 33),
          SizedBox(
            width: 74,
            child: Text('Cantidad', style: AppTextStyles.label),
          ),
        ],
      ),
    );
  }

  Widget _filaUnidad(CalculoProvider calculo, bool activo) {
    final unidadValida = calculo.unidades.contains(unidadSeleccionada)
        ? unidadSeleccionada
        : (calculo.unidades.isNotEmpty ? calculo.unidades.first : null);

    return Padding(
      padding: const EdgeInsets.only(left: 43, right: 39),
      child: Row(
        children: [
          Expanded(
            child: _campoBloqueado(
              activo: activo,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<UnidadModel>(
                  value: unidadValida,
                  dropdownColor: AppColors.primaryDark,
                  iconEnabledColor: AppColors.white,
                  iconDisabledColor: Colors.white70,
                  isExpanded: true,
                  style: AppTextStyles.button,
                  items: calculo.unidades.map((unidad) {
                    return DropdownMenuItem(
                      value: unidad,
                      child: Text(unidad.nombre),
                    );
                  }).toList(),
                  onChanged: activo
                      ? (unidad) {
                          setState(() {
                            unidadSeleccionada = unidad;
                          });
                        }
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 33),
          SizedBox(
            width: 74,
            child: Text('Unidad', style: AppTextStyles.label),
          ),
        ],
      ),
    );
  }

  Widget _filaResultado(bool activo) {
    return Padding(
      padding: const EdgeInsets.only(left: 43, right: 39),
      child: Row(
        children: [
          Expanded(
            child: _campoBloqueado(
              activo: activo,
              child: Center(
                child: Text(
                  !activo || resultadoPreview == 0
                      ? ''
                      : resultadoPreview.toStringAsFixed(2),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 33),
          SizedBox(
            width: 80,
            child: Text('Total cajas', style: AppTextStyles.label),
          ),
        ],
      ),
    );
  }

  Widget _botonesHome(CalculoProvider calculo, bool activo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        children: [
          Expanded(
            child: AppDarkButton(
              text: 'SIGUIENTE',
              onPressed: calculo.cargando || !activo ? null : guardarConversion,
              height: 48,
            ),
          ),
          const SizedBox(width: 46),
          Expanded(
            child: AppDarkButton(
              text: 'FINALIZAR',
              onPressed: calculo.cargando || !activo ? null : finalizarCliente,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }

  String _hora(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      return '$hour:$minute';
    } catch (_) {
      return '--:--';
    }
  }

  String formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();

    return '$dia/$mes/$year';
  }
}
