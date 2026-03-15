import 'package:flutter/material.dart';
import 'package:frontend/src/shared/theme/app_colors.dart';

class RecallColorScheme extends ThemeExtension<RecallColorScheme> {
  final Color background;
  final Color surface;
  final Color onSurface;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color error;
  final Color onError;
  final Color outline;
  final Color accent;

  const RecallColorScheme({
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.onError,
    required this.outline,
    required this.accent,
  });

  RecallColorScheme.light()
    : background = AppColors.colourWhite,
      surface = const Color(0xFFF8F8F8),
      onSurface = AppColors.colourBlack,
      primary = AppColors.primary,
      onPrimary = AppColors.colourWhite,
      secondary = AppColors.secondary,
      onSecondary = AppColors.colourBlack,
      error = const Color(0xFFED1F15),
      onError = AppColors.colourWhite,
      outline = const Color(0xFFD8D8D8),
      accent = AppColors.accent;

  RecallColorScheme.dark()
    : background = AppColors.colourBlack,
      surface = const Color(0xFF1A1A1A),
      onSurface = AppColors.colourWhite,
      primary = AppColors.primary,
      onPrimary = AppColors.colourWhite,
      secondary = AppColors.secondary,
      onSecondary = AppColors.colourBlack,
      error = const Color(0xFFED1F15),
      onError = AppColors.colourWhite,
      outline = const Color(0xFF2A2A2A),
      accent = AppColors.accent;

  @override
  RecallColorScheme copyWith({
    Color? background,
    Color? surface,
    Color? onSurface,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? error,
    Color? onError,
    Color? outline,
    Color? accent,
  }) {
    return RecallColorScheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      outline: outline ?? this.outline,
      accent: accent ?? this.accent,
    );
  }

  @override
  RecallColorScheme lerp(covariant RecallColorScheme? other, double t) {
    if (other is! RecallColorScheme) return this;
    return RecallColorScheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
