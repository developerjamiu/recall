import 'package:flutter/material.dart';
import 'package:frontend/src/shared/theme/app_colors.dart';

class RecallTextTheme extends ThemeExtension<RecallTextTheme> {
  final TextStyle? heading1;
  final TextStyle? heading2;
  final TextStyle? heading3;
  final TextStyle? heading4;
  final TextStyle? heading5;
  final TextStyle? heading6;
  final TextStyle? label;
  final TextStyle? bodyLarge;
  final TextStyle? body;
  final TextStyle? smallBody;
  final TextStyle? bodyLight;

  const RecallTextTheme({
    this.heading1,
    this.heading2,
    this.heading3,
    this.heading4,
    this.heading5,
    this.heading6,
    this.label,
    this.bodyLarge,
    this.body,
    this.smallBody,
    this.bodyLight,
  });

  RecallTextTheme.light()
    : heading1 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 60,
        fontWeight: FontWeight.w900,
        height: 68.0.toDesignHeight(60),
        color: AppColors.colourBlack,
      ),
      heading2 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 48,
        height: 120.0.toDesignHeight(48),
        fontWeight: FontWeight.w900,
        color: AppColors.colourBlack,
      ),
      heading3 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 36,
        height: 120.0.toDesignHeight(36),
        fontWeight: FontWeight.w900,
        color: AppColors.colourBlack,
      ),
      heading4 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 30,
        height: 24.0.toDesignHeight(30),
        fontWeight: FontWeight.w900,
        color: AppColors.colourBlack,
      ),
      heading5 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 24,
        height: 24.0.toDesignHeight(24),
        fontWeight: FontWeight.w900,
        color: AppColors.colourBlack,
      ),
      heading6 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 20,
        height: 24.0.toDesignHeight(20),
        fontWeight: FontWeight.w900,
        color: AppColors.colourBlack,
      ),
      label = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.colourBlack,
      ),
      bodyLarge = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 16,
        height: 24.0.toDesignHeight(16),
        fontWeight: FontWeight.w400,
        color: AppColors.colourBlack,
      ),
      body = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 14,
        height: 24.0.toDesignHeight(14),
        fontWeight: FontWeight.w400,
        color: AppColors.colourBlack,
      ),
      smallBody = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 10,
        height: 16.0.toDesignHeight(10),
        fontWeight: FontWeight.w400,
        color: AppColors.colourBlack,
      ),
      bodyLight = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: AppColors.colourBlack,
      );

  RecallTextTheme.dark()
    : heading1 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 60,
        fontWeight: FontWeight.w900,
        height: 68.0.toDesignHeight(60),
        color: AppColors.colourWhite,
      ),
      heading2 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 48,
        height: 120.0.toDesignHeight(48),
        fontWeight: FontWeight.w900,
        color: AppColors.colourWhite,
      ),
      heading3 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 36,
        height: 120.0.toDesignHeight(36),
        fontWeight: FontWeight.w900,
        color: AppColors.colourWhite,
      ),
      heading4 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 30,
        height: 24.0.toDesignHeight(30),
        fontWeight: FontWeight.w900,
        color: AppColors.colourWhite,
      ),
      heading5 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 24,
        height: 24.0.toDesignHeight(24),
        fontWeight: FontWeight.w900,
        color: AppColors.colourWhite,
      ),
      heading6 = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 20,
        height: 24.0.toDesignHeight(20),
        fontWeight: FontWeight.w900,
        color: AppColors.colourWhite,
      ),
      label = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.colourWhite,
      ),
      bodyLarge = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 16,
        height: 24.0.toDesignHeight(16),
        fontWeight: FontWeight.w400,
        color: AppColors.colourWhite,
      ),
      body = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 14,
        height: 24.0.toDesignHeight(14),
        fontWeight: FontWeight.w400,
        color: AppColors.colourWhite,
      ),
      smallBody = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 10,
        height: 16.0.toDesignHeight(10),
        fontWeight: FontWeight.w400,
        color: AppColors.colourWhite,
      ),
      bodyLight = TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: AppColors.colourWhite,
      );

  @override
  RecallTextTheme copyWith({
    TextStyle? heading1,
    TextStyle? heading2,
    TextStyle? heading3,
    TextStyle? heading4,
    TextStyle? heading5,
    TextStyle? heading6,
    TextStyle? label,
    TextStyle? bodyLarge,
    TextStyle? body,
    TextStyle? smallBody,
    TextStyle? bodyLight,
  }) {
    return RecallTextTheme(
      heading1: heading1 ?? this.heading1,
      heading2: heading2 ?? this.heading2,
      heading3: heading3 ?? this.heading3,
      heading4: heading4 ?? this.heading4,
      heading5: heading5 ?? this.heading5,
      heading6: heading6 ?? this.heading6,
      label: label ?? this.label,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      body: body ?? this.body,
      smallBody: smallBody ?? this.smallBody,
      bodyLight: bodyLight ?? this.bodyLight,
    );
  }

  @override
  RecallTextTheme lerp(covariant RecallTextTheme? other, double t) {
    if (other is! RecallTextTheme) return this;
    return RecallTextTheme(
      heading1: TextStyle.lerp(heading1, other.heading1, t),
      heading2: TextStyle.lerp(heading2, other.heading2, t),
      heading3: TextStyle.lerp(heading3, other.heading3, t),
      heading4: TextStyle.lerp(heading4, other.heading4, t),
      heading5: TextStyle.lerp(heading5, other.heading5, t),
      heading6: TextStyle.lerp(heading6, other.heading6, t),
      label: TextStyle.lerp(label, other.label, t),
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t),
      body: TextStyle.lerp(body, other.body, t),
      smallBody: TextStyle.lerp(smallBody, other.smallBody, t),
      bodyLight: TextStyle.lerp(bodyLight, other.bodyLight, t),
    );
  }
}

extension DesignDimension on double {
  double toDesignHeight(double fontSize) => this / fontSize;
}
