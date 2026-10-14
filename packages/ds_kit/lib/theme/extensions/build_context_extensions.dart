import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Quanto precisamos subir o conteúdo para não ser sobreposto.
/// - Android sem teclado: usa viewPadding.bottom (barra de navegação)
/// - Com teclado ou demais plataformas: offset fixo de 16
double safeBottomOffset(BuildContext context) {
  final mq = MediaQuery.of(context);
  if (mq.viewInsets.bottom > 0) return 16.0;
  final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  return isAndroid ? mq.viewPadding.bottom : 16.0;
}

/// Larguras de referência para layouts responsivos na web.
abstract final class SimBreakpoints {
  /// Abaixo disso, layout de celular (menu vira gaveta).
  static const double compacto = 720;

  /// A partir disso, layout de desktop completo (menu lateral expandido).
  static const double largo = 1200;
}

///
/// Extensions for [BuildContext] class
///
extension BuildContextExtesions on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Largura atual da tela
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Altura atual da tela
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
}
