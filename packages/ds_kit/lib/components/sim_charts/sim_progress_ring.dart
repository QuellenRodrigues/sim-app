import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Anel de progresso com conteúdo no centro (ex.: capacidade da fábrica).
class SimProgressRing extends StatelessWidget {
  const SimProgressRing({
    required this.valor,
    required this.color,
    required this.trackColor,
    super.key,
    this.size = 120,
    this.strokeWidth = 12,
    this.child,
    this.semanticsLabel,
  });

  /// Fração preenchida, de 0 a 1 (valores acima de 1 fecham o anel).
  final double valor;
  final Color color;
  final Color trackColor;
  final double size;
  final double strokeWidth;
  final Widget? child;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _RingPainter(valor.clamp(0, 1).toDouble(), color, trackColor, strokeWidth),
          child: Center(child: ExcludeSemantics(child: child)),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.valor, this.color, this.trackColor, this.strokeWidth);

  final double valor;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Offset(strokeWidth / 2, strokeWidth / 2) & Size(size.width - strokeWidth, size.height - strokeWidth);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, 0, math.pi * 2, false, base..color = trackColor);
    if (valor > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * valor,
        false,
        base
          ..color = color
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.valor != valor || old.color != color || old.trackColor != trackColor;
}
