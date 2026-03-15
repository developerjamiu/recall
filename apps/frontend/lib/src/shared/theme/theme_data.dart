import 'package:flutter/material.dart';
import 'package:frontend/src/shared/theme/color_scheme.dart';
import 'package:frontend/src/shared/theme/text_theme.dart';

class RecallTheme extends ThemeExtension<RecallTheme> {
  final RecallTextTheme textTheme;
  final RecallColorScheme colorScheme;

  const RecallTheme({required this.textTheme, required this.colorScheme});

  static RecallTheme of(BuildContext context) {
    return Theme.of(context).extension<RecallTheme>()!;
  }

  RecallTheme.light()
    : textTheme = RecallTextTheme.light(),
      colorScheme = RecallColorScheme.light();

  RecallTheme.dark()
    : textTheme = RecallTextTheme.dark(),
      colorScheme = RecallColorScheme.dark();

  @override
  RecallTheme copyWith({
    RecallTextTheme? textTheme,
    RecallColorScheme? colorScheme,
  }) {
    return RecallTheme(
      textTheme: textTheme ?? this.textTheme,
      colorScheme: colorScheme ?? this.colorScheme,
    );
  }

  @override
  RecallTheme lerp(covariant RecallTheme? other, double t) {
    if (other is! RecallTheme) return this;
    return RecallTheme(
      textTheme: textTheme.lerp(other.textTheme, t),
      colorScheme: colorScheme.lerp(other.colorScheme, t),
    );
  }
}
