import 'package:flutter/material.dart';

import '../../theme/tokens/tokens.dart';
import '../../theme/typography/sim_typography.dart';

/// Avatar com iniciais (clientes, usuários).
class SimAvatar extends StatelessWidget {
  const SimAvatar({
    required this.iniciais,
    super.key,
    this.background = SimTokens.colorPrimary100,
    this.foreground = SimTokens.colorPrimary900,
    this.size = 40,
    this.circular = false,
  });

  final String iniciais;
  final Color background;
  final Color foreground;
  final double size;
  final bool circular;

  /// Iniciais das duas primeiras palavras relevantes de um nome.
  static String iniciaisDe(String nome) {
    const ignoradas = {'da', 'de', 'do', 'das', 'dos', 'e', 'ltda', 'ltda.', 's.a.', 'me'};
    final palavras = nome
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty && !ignoradas.contains(p.toLowerCase()))
        .toList();
    if (palavras.isEmpty) return '?';
    final primeira = palavras.first[0];
    final segunda = palavras.length > 1 ? palavras[1][0] : '';
    return '$primeira$segunda'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular ? null : BorderRadius.circular(size / 4),
      ),
      child: Text(
        iniciais,
        style: SimTypography.bodySmSemiBold.copyWith(color: foreground, fontSize: size * 0.33),
      ),
    );
  }
}
