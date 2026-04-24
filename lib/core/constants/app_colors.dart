import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Okabe-Ito color-blind safe palette
  static const Color orange = Color(0xFFE69F00);
  static const Color skyBlue = Color(0xFF56B4E9);
  static const Color bluishGreen = Color(0xFF009E73);
  static const Color yellow = Color(0xFFF0E442);
  static const Color blue = Color(0xFF0072B2);
  static const Color vermillion = Color(0xFFD55E00);
  static const Color reddishPurple = Color(0xFFCC79A7);
  static const Color black = Color(0xFF000000);

  static const List<Color> okabeIto = [
    orange,
    skyBlue,
    bluishGreen,
    yellow,
    blue,
    vermillion,
    reddishPurple,
    black,
  ];

  // Indices 0–6 are safe for card backgrounds (exclude black at index 7)
  static const int paletteColorCount = 7;

  static Color textColorOn(Color background) {
    return background.computeLuminance() > 0.4
        ? const Color(0xFF1A1A1A)
        : Colors.white;
  }

  // App-level semantic colors
  static const Color pastBadge = Color(0xFF757575);
  static const Color upcomingBadge = Color(0xFF0072B2);
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color cardSurface = Colors.white;
  static const Color primarySeed = Color(0xFF0072B2);
}
