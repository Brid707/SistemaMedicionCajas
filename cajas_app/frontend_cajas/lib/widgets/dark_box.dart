import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class DarkBox extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry padding;

  const DarkBox({
    super.key,
    required this.child,
    this.height = 68,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.inputDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
