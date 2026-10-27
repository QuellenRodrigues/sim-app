import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Situações que pedem uma ação, cada uma com a ação sugerida ao lado.
class HomeAtencaoCard extends StatelessWidget {
  const HomeAtencaoCard({
    required this.alertas,
    required this.onAcao,
    super.key,
  });

  final List<AlertaModel> alertas;
  final ValueChanged<AlertaModel> onAcao;

  @override
  Widget build(BuildContext context) {
    return SimCard(
      titulo: 'Precisa de atenção',
      tituloSufixo: alertas.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: SimTokens.colorError500,
                borderRadius: BorderRadius.circular(SimTokens.roundedMax),
              ),
              child: Text(
                '${alertas.length}',
                style: SimTypography.labelSmMedium.copyWith(
                  color: SimTokens.colorWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
      padding: EdgeInsets.fromLTRB(Spacing.md.width, Spacing.xs.height, Spacing.md.width, Spacing.sm.height),
      child: alertas.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: Spacing.xs.height),
              child: Row(
                children: [
                  const Icon(Icons.task_alt, color: SimTokens.colorSuccess500),
                  Spacing.xs.horizontal,
                  Text('Tudo em ordem por aqui.', style: SimTypography.bodySmRegular),
                ],
              ),
            )
          : Column(
              children: [
                for (final (i, alerta) in alertas.indexed) ...[
                  if (i > 0) const Divider(color: SimTokens.colorNeutral100),
                  _ItemAlerta(alerta: alerta, onAcao: () => onAcao(alerta)),
                ],
              ],
            ),
    );
  }
}

class _ItemAlerta extends StatelessWidget {
  const _ItemAlerta({required this.alerta, required this.onAcao});

  final AlertaModel alerta;
  final VoidCallback onAcao;

  @override
  Widget build(BuildContext context) {
    final (icone, tipo) = switch (alerta.tipo) {
      TipoAlerta.atraso => (Icons.schedule, SimStatusType.erro),
      TipoAlerta.sobrecarga => (Icons.warning_amber_rounded, SimStatusType.alerta),
      TipoAlerta.materialPendente => (Icons.inventory_2_outlined, SimStatusType.alerta),
    };

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.xs.height),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(color: tipo.background, shape: BoxShape.circle),
            child: Icon(icone, size: 18, color: tipo.foreground),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(alerta.titulo, style: SimTypography.bodySmSemiBold),
                ),
                const SizedBox(height: 2),
                Text(
                  alerta.descricao,
                  style: SimTypography.bodySmRegular.copyWith(fontSize: 13, color: SimTokens.colorNeutral500),
                ),
                TextButton(
                  onPressed: onAcao,
                  style: TextButton.styleFrom(
                    foregroundColor: SimTokens.colorPrimary500,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 40),
                    textStyle: SimTypography.bodySmSemiBold.copyWith(fontSize: 13),
                  ),
                  child: Text(alerta.acao),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
