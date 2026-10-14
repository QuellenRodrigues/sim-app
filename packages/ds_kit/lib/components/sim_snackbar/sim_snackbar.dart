import 'package:flutter/material.dart';

import '../../theme/tokens/tokens.dart';
import '../../theme/typography/sim_typography.dart';

/// Variante visual do snackbar: define cor e ícone.
enum SimSnackBarType {
  info(SimTokens.colorInfo500, Icons.info_outline),
  success(SimTokens.colorSuccess500, Icons.check_circle_outline),
  warning(SimTokens.colorWarning500, Icons.warning_amber_rounded),
  error(SimTokens.colorError500, Icons.error_outline);

  const SimSnackBarType(this.color, this.icon);

  final Color color;
  final IconData icon;
}

/// Mensagem temporária no rodapé da tela.
///
/// ```dart
/// SimSnackBar(
///   title: 'Atenção!',
///   message: 'Esta funcionalidade ainda não está disponível.',
///   type: SimSnackBarType.warning,
/// ).show(context);
/// ```
class SimSnackBar {
  const SimSnackBar({
    required this.message,
    this.title,
    this.type = SimSnackBarType.info,
    this.duration = const Duration(seconds: 4),
  });

  final String? title;
  final String message;
  final SimSnackBarType type;
  final Duration duration;

  void show(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        width: 420,
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(type.icon, color: type.color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(title!, style: SimTypography.bodySmSemiBold.copyWith(color: SimTokens.colorWhite)),
                  Text(
                    message,
                    style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral200),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
