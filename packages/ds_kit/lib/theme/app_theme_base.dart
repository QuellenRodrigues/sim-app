import 'package:flutter/material.dart';

import 'tokens/tokens.dart';
import 'typography/sim_typography.dart';

class AppThemeBase {
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: SimTokens.colorPrimary500,
    onPrimary: SimTokens.colorWhite,
    primaryContainer: SimTokens.colorPrimary100,
    onPrimaryContainer: SimTokens.colorPrimary900,
    secondary: SimTokens.colorSuccess500,
    onSecondary: SimTokens.colorWhite,
    secondaryContainer: SimTokens.colorSuccess100,
    onSecondaryContainer: SimTokens.colorSuccess700,
    tertiary: SimTokens.colorNeutral800,
    onTertiary: SimTokens.colorWhite,
    error: SimTokens.colorError500,
    onError: SimTokens.colorWhite,
    errorContainer: SimTokens.colorError100,
    onErrorContainer: SimTokens.colorError700,
    surface: SimTokens.colorWhite,
    onSurface: SimTokens.colorNeutral800,
    onSurfaceVariant: SimTokens.colorNeutral600,
    surfaceContainerLowest: SimTokens.colorWhite,
    surfaceContainerLow: SimTokens.colorNeutral50,
    surfaceContainer: SimTokens.colorNeutral100,
    surfaceContainerHigh: SimTokens.colorNeutral200,
    surfaceContainerHighest: SimTokens.colorNeutral300,
    outline: SimTokens.colorNeutral300,
    outlineVariant: SimTokens.colorNeutral200,
    inverseSurface: SimTokens.colorNeutral800,
    onInverseSurface: SimTokens.colorNeutral50,
    inversePrimary: SimTokens.colorPrimary300,
    shadow: SimColors.black,
    scrim: SimColors.black,
  );

  static ThemeData get theme {
    final controlShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(SimTokens.roundedSm));

    OutlineInputBorder border(Color color, [double width = SimTokens.borderSm]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(SimTokens.roundedSm),
      borderSide: BorderSide(color: color, width: width),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'packages/${SimTypography.package}/${SimTypography.fontFamily}',
      textTheme: SimTypography.textTheme,
      scaffoldBackgroundColor: SimTokens.colorNeutral50,
      dividerTheme: const DividerThemeData(color: SimTokens.colorNeutral200, thickness: 1, space: 1),
      iconTheme: const IconThemeData(color: SimTokens.colorNeutral600, size: 22),
      appBarTheme: AppBarTheme(
        backgroundColor: SimTokens.colorWhite,
        foregroundColor: SimTokens.colorNeutral800,
        surfaceTintColor: SimTokens.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: SimTypography.titleSmSemiBold,
        shape: const Border(bottom: BorderSide(color: SimTokens.colorNeutral200)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: controlShape, textStyle: SimTypography.bodySmSemiBold),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: controlShape,
          textStyle: SimTypography.bodySmSemiBold,
          foregroundColor: SimTokens.colorNeutral800,
          side: const BorderSide(color: SimTokens.colorNeutral300),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: controlShape, textStyle: SimTypography.bodySmSemiBold),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SimTokens.colorWhite,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
        border: border(SimTokens.colorNeutral300),
        enabledBorder: border(SimTokens.colorNeutral300),
        focusedBorder: border(SimTokens.colorPrimary500, SimTokens.borderMd),
        errorBorder: border(SimTokens.colorError500),
        focusedErrorBorder: border(SimTokens.colorError500, SimTokens.borderMd),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: SimTokens.colorNeutral800,
          borderRadius: BorderRadius.circular(SimTokens.rounded2xs),
        ),
        textStyle: SimTypography.bodyXsRegular.copyWith(color: SimTokens.colorWhite),
        waitDuration: const Duration(milliseconds: 400),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: SimTokens.colorNeutral800,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SimTokens.roundedMd)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SimTokens.colorPrimary500,
        linearTrackColor: SimTokens.colorNeutral100,
      ),
    );
  }
}
