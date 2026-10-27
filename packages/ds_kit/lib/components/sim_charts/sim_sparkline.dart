import 'package:flutter/material.dart';

/// Minigráfico de linha para mostrar a tendência de um indicador.
class SimSparkline extends StatelessWidget {
  const SimSparkline({
    required this.valores,
    required this.color,
    super.key,
    this.height = 34,
  });

  final List<double> valores;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _SparklinePainter(valores, color)),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.valores, this.color);

  final List<double> valores;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (valores.length < 2) return;
    final minimo = valores.reduce((a, b) => a < b ? a : b);
    final maximo = valores.reduce((a, b) => a > b ? a : b);
    final amplitude = (maximo - minimo) == 0 ? 1 : maximo - minimo;
    const margem = 3.0;
    final alturaUtil = size.height - margem * 2;

    final path = Path();
    for (var i = 0; i < valores.length; i++) {
      final x = size.width * i / (valores.length - 1);
      final y = margem + alturaUtil * (1 - (valores[i] - minimo) / amplitude);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.valores != valores || old.color != color;
}
