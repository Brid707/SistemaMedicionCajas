import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle titleLarge = GoogleFonts.breeSerif(
    fontSize: 31,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
    height: 1.0,
  );

  static TextStyle titleMedium = GoogleFonts.breeSerif(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );

  static TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryDark,
    height: 1.25,
    letterSpacing: 0.5,
  );

  static TextStyle sectionTitle = GoogleFonts.breeSerif(
    fontSize: 21,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );

  static TextStyle label = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  static TextStyle button = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle normal = GoogleFonts.poppins(
    fontSize: 15,
    color: AppColors.textBlack,
  );

  static TextStyle bottomNav = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.white,
  );
}
