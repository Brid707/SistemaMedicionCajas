import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class AppDarkButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double? width;

  const AppDarkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 50,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonDark,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button,
          textAlign: TextAlign.center,
        ),
      ),
    );

    return button;
  }
}
