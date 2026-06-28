import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../models/cliente_model.dart';
import '../models/ruta_model.dart';
import '../providers/calculo_provider.dart';
import '../widgets/app_dark_button.dart';
import '../widgets/app_header.dart';
import '../widgets/dark_box.dart';
import 'cliente_detalle_screen.dart';

class RutaScreen extends StatelessWidget {
  final CalculoProvider calculo;
  final VoidCallback? onCrearRuta;
  final VoidCallback? onFinalizarRuta;
  final Future<void> Function()? onRecargar;

  const RutaScreen({
    super.key,
    required this.calculo,
    required this.onCrearRuta,
    required this.onFinalizarRuta,
    required this.onRecargar,
  });

  @override
  Widget build(BuildContext context) {
    final rutaActiva = calculo.rutaActiva;
    final rutas = calculo.rutas;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(
            titulo: 'Ruta',
            subtitulo: 'CONTROL DE\nRUTAS',
            icon: Icons.route_outlined,
          ),

          const SizedBox(height: 24),

          if (rutaActiva == null)
            _sinRutaActiva()
          else
            _rutaActiva(context, rutaActiva),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              'Rutas registradas:',
              style: AppTextStyles.sectionTitle,
            ),
          ),

          const SizedBox(height: 14),

          if (rutas.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Text(
                'Aún no hay rutas registradas.',
                style: AppTextStyles.normal,
              ),
            )
          else
            ...rutas.map((ruta) {
              return _tarjetaRutaRegistrada(ruta);
            }),
        ],
      ),
    );
  }

  Widget _sinRutaActiva() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DarkBox(
            height: null,
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Text(
                  'NO HAY RUTA ACTIVA',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.button.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Crea una ruta para poder agregar clientes y capturar cajas.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.button,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppDarkButton(text: 'NUEVA RUTA', onPressed: onCrearRuta, height: 48),
        ],
      ),
    );
  }

  Widget _rutaActiva(BuildContext context, RutaModel ruta) {
    final clientes = ruta.clientes;
    final totalGeneral = _totalGeneralCalculado(ruta);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DarkBox(
            height: null,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RUTA ACTIVA',
                  style: AppTextStyles.button.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                _lineaDato('Folio:', ruta.folioRuta),
                _lineaDato('Estado:', ruta.estado),
                _lineaDato('Inicio:', _fechaCorta(ruta.creadoEn)),
                _lineaDato('Clientes:', clientes.length.toString()),
                const SizedBox(height: 14),
                Text(
                  'TOTAL GENERAL: ${totalGeneral.toStringAsFixed(2)} CAJAS',
                  style: AppTextStyles.button.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _totalesPorUnidad(ruta),

          const SizedBox(height: 24),

          Text('Clientes de la ruta:', style: AppTextStyles.sectionTitle),

          const SizedBox(height: 12),

          if (clientes.isEmpty)
            Text(
              'Aún no hay clientes en esta ruta.',
              style: AppTextStyles.normal,
            )
          else
            ...clientes.map((cliente) {
              return _tarjetaClienteRuta(context, cliente);
            }),

          const SizedBox(height: 24),

          AppDarkButton(
            text: 'FINALIZAR RUTA',
            onPressed: onFinalizarRuta,
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _totalesPorUnidad(RutaModel ruta) {
    final totales = ruta.totalesPorUnidad;
    final totalGeneral = _totalGeneralCalculado(ruta);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Totales por unidad:', style: AppTextStyles.sectionTitle),

        const SizedBox(height: 12),

        if (totales.isEmpty)
          Text(
            'Aún no hay unidades capturadas en esta ruta.',
            style: AppTextStyles.normal,
          )
        else
          ...totales.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DarkBox(
                height: null,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.unidadNombre.toUpperCase(),
                      style: AppTextStyles.button.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _lineaDato(
                      'Cantidad total:',
                      item.totalCantidad.toStringAsFixed(2),
                    ),
                    _lineaDato('Cajas:', item.totalCajas.toStringAsFixed(2)),
                  ],
                ),
              ),
            );
          }),

        if (totales.isNotEmpty) ...[
          const SizedBox(height: 8),
          DarkBox(
            height: null,
            padding: const EdgeInsets.all(14),
            child: Center(
              child: Text(
                'SUMATORIA TOTAL DE RUTA: ${totalGeneral.toStringAsFixed(2)} CAJAS',
                textAlign: TextAlign.center,
                style: AppTextStyles.button.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _tarjetaClienteRuta(BuildContext context, ClienteModel cliente) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClienteDetalleScreen(cliente: cliente),
            ),
          ).then((_) {
            if (onRecargar != null) {
              onRecargar!();
            }
          });
        },
        child: DarkBox(
          height: 72,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'CLIENTE ${cliente.id}\n${cliente.estado}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.button,
                ),
              ),
              Text(
                '${cliente.totalCajas.toStringAsFixed(2)} CAJAS',
                textAlign: TextAlign.center,
                style: AppTextStyles.button.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarjetaRutaRegistrada(RutaModel ruta) {
    final bool activa = ruta.estado == 'ACTIVA';
    final totalGeneral = _totalGeneralCalculado(ruta);

    return Padding(
      padding: const EdgeInsets.only(left: 43, right: 37, bottom: 12),
      child: DarkBox(
        height: null,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activa ? 'EN RUTA' : 'RUTA FINALIZADA',
              style: AppTextStyles.button.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),

            _lineaDato('Folio:', ruta.folioRuta),
            _lineaDato('Inicio:', _fechaCorta(ruta.creadoEn)),

            if (ruta.finalizadoEn != null)
              _lineaDato('Fin:', _fechaCorta(ruta.finalizadoEn!)),

            _lineaDato('Clientes:', ruta.clientes.length.toString()),

            const SizedBox(height: 14),

            Text(
              'Totales por unidad:',
              style: AppTextStyles.button.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            if (ruta.totalesPorUnidad.isEmpty)
              Text('Sin unidades capturadas.', style: AppTextStyles.button)
            else
              ...ruta.totalesPorUnidad.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.buttonDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.unidadNombre.toUpperCase(),
                          style: AppTextStyles.button.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cantidad total: ${item.totalCantidad.toStringAsFixed(2)}',
                          style: AppTextStyles.button,
                        ),
                        Text(
                          'Cajas: ${item.totalCajas.toStringAsFixed(2)}',
                          style: AppTextStyles.button,
                        ),
                      ],
                    ),
                  ),
                );
              }),

            const SizedBox(height: 10),

            Text(
              'TOTAL GENERAL: ${totalGeneral.toStringAsFixed(2)} CAJAS',
              style: AppTextStyles.button.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _totalGeneralCalculado(RutaModel ruta) {
    if (ruta.totalesPorUnidad.isEmpty) {
      return ruta.totalCajas;
    }

    return ruta.totalesPorUnidad.fold<double>(
      0,
      (suma, item) => suma + item.totalCajas,
    );
  }

  Widget _lineaDato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              titulo,
              style: AppTextStyles.button.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(child: Text(valor, style: AppTextStyles.button)),
        ],
      ),
    );
  }

  String _fechaCorta(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      final dia = date.day.toString().padLeft(2, '0');
      final mes = date.month.toString().padLeft(2, '0');
      final hora = date.hour.toString().padLeft(2, '0');
      final minuto = date.minute.toString().padLeft(2, '0');

      return '$dia/$mes $hora:$minuto';
    } catch (_) {
      return fecha;
    }
  }
}
