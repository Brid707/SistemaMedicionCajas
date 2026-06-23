import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icon;

  const AppHeader({
    super.key,
    required this.titulo,
    required this.subtitulo,
    this.icon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 222,
      width: double.infinity,
      color: AppColors.headerBackground,
      padding: const EdgeInsets.only(left: 31, top: 43, right: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 56, color: AppColors.textBlack),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: AppTextStyles.titleLarge),
                  Text(subtitulo, style: AppTextStyles.subtitle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
