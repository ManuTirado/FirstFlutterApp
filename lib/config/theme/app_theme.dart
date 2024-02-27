import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppColors {
  primary(Color(0xFFC980E6)),
  secondary(Color(0xFF6C1EE3)),
  terniary(Color(0xFF5204D9)),
  backgroundLight(Color(0xFFD1D8E0)),
  backgroundDark(Color(0xFF2C3E50)),
  error(Color(0xFFEB4263)),
  succes(Color(0xFFBCD94A));

  final Color color;
  const AppColors(this.color);
}

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
          foregroundColor: AppColors.primary.color,
          backgroundColor: AppColors.backgroundDark.color,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light),
      scaffoldBackgroundColor: AppColors.backgroundLight.color,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary.color),
      useMaterial3: true,
    );
  }
}
