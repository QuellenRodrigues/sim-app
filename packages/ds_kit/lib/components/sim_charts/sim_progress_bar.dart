import 'package:flutter/material.dart';

import '../../theme/tokens/tokens.dart';

/// Barra de progresso fina e arredondada.
class SimProgressBar extends StatelessWidget {
  const SimProgressBar({
    required this.valor,
    required this.color,
    super.key,
    this.trackColor = SimTokens.colorNeutral100,
    this.height = 6,
  });

  /// Fração preenchida, de 0 a 1.
  final double valor;
  final Color color;
  final Color trackColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final raio = BorderRadius.circular(SimTokens.roundedMax);
    return ExcludeSemantics(
      child: Container(
        height: height,
        decoration: BoxDecoration(color: trackColor, borderRadius: raio),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: valor.clamp(0, 1).toDouble(),
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, borderRadius: raio),
          ),
        ),
      ),
    );
  }
}
