import 'package:flutter/material.dart';

///
/// [String] extension to access ds_kit assets
///
extension BaseAppAssetsStringExtension on String {
  ///
  /// Get a local image asset
  ///
  AssetImage get baseAppImage {
    return AssetImage(
      'assets/images/$this',
      package: AppAssets.package,
    );
  }
}

///
/// Utility class to access app assets.
///
abstract class AppAssets {
  static const String package = 'ds_kit';

  /// Logo
  static const String logoSimboloSvg = 'assets/images/logo_simbolo.svg';
  static const String logoSimboloNegativoSvg = 'assets/images/logo_simbolo_negativo.svg';
}
