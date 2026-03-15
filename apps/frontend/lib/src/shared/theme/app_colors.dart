import 'package:flutter/material.dart';

abstract class AppColors {
  static const colourBlack = Color(0xFF101010);

  static const colourWhite = Color(0xFFF4F4F4);

  static const MaterialColor primary = MaterialColor(0xFF00A3AF, {
    50: Color(0xFFE0F7F9),
    100: Color(0xFFB3ECF0),
    200: Color(0xFF80DFE6),
    300: Color(0xFF4DD2DC),
    400: Color(0xFF26C8D5),
    500: Color(0xFF00A3AF),
    600: Color(0xFF009299),
    700: Color(0xFF007F85),
    800: Color(0xFF006D72),
    900: Color(0xFF004D51),
  });

  static const MaterialColor secondary = MaterialColor(0xFF00727A, {
    50: Color(0xFFE0F2F3),
    100: Color(0xFFB3DFE2),
    200: Color(0xFF80CBCF),
    300: Color(0xFF4DB6BC),
    400: Color(0xFF26A6AD),
    500: Color(0xFF00727A),
    600: Color(0xFF00656D),
    700: Color(0xFF00565D),
    800: Color(0xFF00474E),
    900: Color(0xFF002F34),
  });

  static const MaterialColor accent = MaterialColor(0xFFFFA368, {
    50: Color(0xFFFFF3EC),
    100: Color(0xFFFFE0CC),
    200: Color(0xFFFFCCAA),
    300: Color(0xFFFFB888),
    400: Color(0xFFFFAD78),
    500: Color(0xFFFFA368),
    600: Color(0xFFE8924D),
    700: Color(0xFFCC7D3A),
    800: Color(0xFFB06828),
    900: Color(0xFF804515),
  });
}
