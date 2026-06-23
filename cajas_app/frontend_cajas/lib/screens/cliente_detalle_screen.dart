import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../models/cliente_model.dart';
import '../widgets/app_header.dart';
import '../widgets/dark_box.dart';

class ClienteDetalleScreen extends StatelessWidget {
  final ClienteModel cliente;

  const ClienteDetalleScreen({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                const AppHeader(
                  titulo: 'Detalle',
                  subtitulo: 'CONSULTA DEL\nCLIENTE',
                ),
                Positioned(
                  top: 12,
                  right: 18,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(36, 28, 36, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _resumenCliente(),
                    const SizedBox(height: 28),
                    Text(
                      'Detalle de conversiones:',
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: 16),
                    if (cliente.conversiones.isEmpty)
                      Text(
                        'Este cliente no tiene conversiones registradas.',
                        style: AppTextStyles.normal,
                      )
                    else
                      ...cliente.conversiones.map((conversion) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: DarkBox(
                            height: null,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  conversion.unidadNombre.toUpperCase(),
                                  style: AppTextStyles.button.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _lineaDato(
                                  'Cantidad:',
                                  conversion.cantidad.toStringAsFixed(2),
                                ),
                                _lineaDato(
                                  'Equivalente:',
                                  conversion.equivalente.toStringAsFixed(2),
                                ),
                                _lineaDato(
                                  'Resultado:',
                                  '${conversion.resultadoCajas.toStringAsFixed(2)} cajas',
                                ),
                                _lineaDato(
                                  'Hora:',
                                  _fechaCorta(conversion.creadoEn),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumenCliente() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DarkBox(
          height: null,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CLIENTE ${cliente.id}',
                style: AppTextStyles.button.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              _lineaDato('Folio:', cliente.folioCliente),
              _lineaDato('Estado:', cliente.estado),
              _lineaDato('Creado:', _fechaCorta(cliente.creadoEn)),
              if (cliente.finalizadoEn != null)
                _lineaDato('Finalizado:', _fechaCorta(cliente.finalizadoEn!)),
              const SizedBox(height: 16),
              Text(
                'TOTAL: ${cliente.totalCajas.toStringAsFixed(2)} CAJAS',
                style: AppTextStyles.button.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lineaDato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
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

      return '$dia/$mes ${hora}:$minuto';
    } catch (_) {
      return fecha;
    }
  }
}
