import 'dart:math' as math;

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Ocupação programada de cada máquina no dia.
class HomeCargaMaquinasCard extends StatelessWidget {
  const HomeCargaMaquinasCard({
    required this.cargas,
    required this.onVerProgramacao,
    super.key,
  });

  final List<CargaMaquinaModel> cargas;
  final VoidCallback onVerProgramacao;

  @override
  Widget build(BuildContext context) {
    return SimCard(
      titulo: 'Carga das máquinas',
      subtitulo: 'Ocupação programada para hoje',
      acao: SimButton(
        label: 'Programação',
        style: SimButtonStyle.texto,
        onPressed: onVerProgramacao,
      ),
      child: Column(
        children: [
          for (final (index, carga) in cargas.indexed) ...[
            if (index > 0) Spacing.sm.vertical,
            _LinhaCarga(carga: carga),
          ],
        ],
      ),
    );
  }
}

class _LinhaCarga extends StatelessWidget {
  const _LinhaCarga({required this.carga});

  final CargaMaquinaModel carga;

  Color get _cor {
    if (carga.emSobrecarga) return SimTokens.colorError500;
    if (carga.ocupacao >= 0.85) return SimTokens.colorWarning500;
    return SimTokens.colorPrimary500;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${carga.maquina}: ${NumberFormatter.percentual(carga.ocupacao)} da capacidade',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(carga.maquina, style: SimTypography.bodySmMedium)),
                if (carga.emSobrecarga) ...[
                  Text(
                    'Sobrecarga',
                    style: SimTypography.labelSmMedium.copyWith(color: SimTokens.colorError700),
                  ),
                  Spacing.xs.horizontal,
                ],
                Text(
                  NumberFormatter.percentual(carga.ocupacao),
                  style: SimTypography.bodySmSemiBold.copyWith(fontFeatures: SimTypography.tabular),
                ),
              ],
            ),
            Spacing.xxs.vertical,
            ClipRRect(
              borderRadius: BorderRadius.circular(SimTokens.roundedMax),
              child: LinearProgressIndicator(
                value: math.min(carga.ocupacao, 1),
                minHeight: 8,
                color: _cor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
