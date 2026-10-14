import 'package:flutter/material.dart';

import '../responsive/responsive_extension.dart';
import '../tokens/tokens.dart';

/// Estilos de texto do SIM.
///
/// - **Jost** (display/títulos): geométrica, mesma família do wordmark "sim".
/// - **Inter** (interface/dados): legível em telas densas.
class SimTypography {
  SimTypography._();

  static const String package = 'ds_kit';
  static const String fontFamilyDisplay = 'Jost';
  static const String fontFamily = 'Inter';

  /// Algarismos de mesma largura, para colunas de valores e quantidades.
  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];

  static final TextStyle displayLgLight = TextStyle(
    fontFamily: fontFamilyDisplay,
    package: package,
    fontWeight: FontWeight.w300,
    fontSize: 40.fontSize,
    height: 48 / 40,
    letterSpacing: -0.4,
    color: SimTokens.colorNeutral800,
  );

  static final TextStyle displayMdMedium = TextStyle(
    fontFamily: fontFamilyDisplay,
    package: package,
    fontWeight: FontWeight.w500,
    fontSize: 32.fontSize,
    height: 38 / 32,
    letterSpacing: -0.3,
    color: SimTokens.colorNeutral800,
    fontFeatures: tabular,
  );

  static final TextStyle titleXlMedium = TextStyle(
    fontFamily: fontFamilyDisplay,
    package: package,
    fontWeight: FontWeight.w500,
    fontSize: 28.fontSize,
    height: 36 / 28,
    letterSpacing: -0.2,
    color: SimTokens.colorNeutral800,
  );

  static final TextStyle titleLgMedium = TextStyle(
    fontFamily: fontFamilyDisplay,
    package: package,
    fontWeight: FontWeight.w500,
    fontSize: 22.fontSize,
    height: 28 / 22,
    letterSpacing: 0,
    color: SimTokens.colorNeutral800,
  );

  static final TextStyle titleMdSemiBold = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontWeight: FontWeight.w600,
    fontSize: 18.fontSize,
    height: 26 / 18,
    letterSpacing: 0,
    color: SimTokens.colorNeutral800,
  );

  static final TextStyle titleSmSemiBold = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontWeight: FontWeight.w600,
    fontSize: 16.fontSize,
    height: 24 / 16,
    letterSpacing: 0,
    color: SimTokens.colorNeutral800,
  );

  static final TextStyle bodyMdRegular = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontWeight: FontWeight.w400,
    fontSize: 16.fontSize,
    height: 24 / 16,
    letterSpacing: 0,
    color: SimTokens.colorNeutral800,
  );

  static final TextStyle bodySmSemiBold = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontWeight: FontWeight.w600,
    fontSize: 14.fontSize,
    height: 20 / 14,
    letterSpacing: 0,
    color: SimTokens.colorNeutral800,
  );

  static final TextStyle bodySmMedium = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontWeight: FontWeight.w500,
    fontSize: 14.fontSize,
    height: 20 / 14,
    letterSpacing: 0,
    color: SimTokens.colorNeutral800,
  );

  static final TextStyle bodySmRegular = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontWeight: FontWeight.w400,
    fontSize: 14.fontSize,
    height: 20 / 14,
    letterSpacing: 0,
    color: SimTokens.colorNeutral800,
  );

  static final TextStyle bodyXsRegular = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontWeight: FontWeight.w400,
    fontSize: 12.fontSize,
    height: 16 / 12,
    letterSpacing: 0,
    color: SimTokens.colorNeutral600,
  );

  static final TextStyle labelSmMedium = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontWeight: FontWeight.w500,
    fontSize: 12.fontSize,
    height: 16 / 12,
    letterSpacing: 0.1,
    color: SimTokens.colorNeutral800,
  );

  /// Rótulo em caixa alta (cabeçalhos de tabela, seções do menu).
  static final TextStyle labelXsSemiBold = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontWeight: FontWeight.w600,
    fontSize: 11.fontSize,
    height: 16 / 11,
    letterSpacing: 0.6,
    color: SimTokens.colorNeutral500,
  );

  /// Wordmark "sim" — use apenas via [SimLogo].
  static TextStyle wordmark(double size, Color color) => TextStyle(
    fontFamily: fontFamilyDisplay,
    package: package,
    fontWeight: FontWeight.w500,
    fontSize: size,
    height: 1,
    letterSpacing: -0.03 * size,
    color: color,
  );

  /// TextTheme do Material derivado dos estilos acima.
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLgLight,
    displayMedium: displayMdMedium,
    headlineLarge: titleXlMedium,
    headlineMedium: titleLgMedium,
    titleLarge: titleMdSemiBold,
    titleMedium: titleSmSemiBold,
    titleSmall: bodySmSemiBold,
    bodyLarge: bodyMdRegular,
    bodyMedium: bodySmRegular,
    bodySmall: bodyXsRegular,
    labelLarge: bodySmMedium,
    labelMedium: labelSmMedium,
    labelSmall: labelXsSemiBold,
  );
}
