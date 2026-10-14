import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import '../typography/sim_typography.dart';

/// Variantes visuais do [SimButton].
enum SimButtonStyle {
  /// Ação principal da tela (púrpura).
  primario,

  /// Ação secundária (contorno).
  secundario,

  /// Ação discreta (só texto).
  texto,
}

/// Botão padrão do SIM.
///
/// ```dart
/// SimButton(
///   label: 'Novo orçamento',
///   icon: Icons.add,
///   onPressed: () => viewModel.novoOrcamento(),
/// )
/// ```
class SimButton extends StatelessWidget {
  const SimButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.style = SimButtonStyle.primario,
    this.icon,
    this.isActive = true,
    this.height = 40,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final SimButtonStyle style;
  final IconData? icon;
  final bool isActive;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final onTap = isActive ? onPressed : null;
    const padding = EdgeInsets.symmetric(horizontal: 16);
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );

    final button = switch (style) {
      SimButtonStyle.primario => FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: SimTokens.colorPrimary500,
          foregroundColor: SimTokens.colorWhite,
          disabledBackgroundColor: SimTokens.colorNeutral200,
          padding: padding,
          textStyle: SimTypography.bodySmSemiBold,
        ),
        child: child,
      ),
      SimButtonStyle.secundario => OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: SimTokens.colorWhite,
          padding: padding,
          textStyle: SimTypography.bodySmSemiBold,
        ),
        child: child,
      ),
      SimButtonStyle.texto => TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: SimTokens.colorPrimary500,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: SimTypography.bodySmSemiBold,
        ),
        child: child,
      ),
    };

    return SizedBox(height: height, width: width, child: button);
  }
}
