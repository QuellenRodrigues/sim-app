import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Painel de detalhe quando nenhum registro está aberto.
class SimPainelVazio extends StatelessWidget {
  const SimPainelVazio({
    required this.icone,
    required this.titulo,
    required this.texto,
    required this.acaoLabel,
    required this.acaoIcone,
    required this.onAcao,
    super.key,
  });

  final IconData icone;
  final String titulo;
  final String texto;
  final String acaoLabel;
  final IconData acaoIcone;
  final VoidCallback onAcao;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SimTokens.colorWhite,
        borderRadius: BorderRadius.circular(SimTokens.roundedLg),
        border: Border.all(color: SimTokens.colorBorder),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(Spacing.lg.width),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(color: SimTokens.colorPrimary50, shape: BoxShape.circle),
            child: Icon(icone, size: 34, color: SimTokens.colorPrimary500),
          ),
          Spacing.sm.vertical,
          Text(titulo, style: SimTypography.titleLgMedium),
          Spacing.xxs.vertical,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
            ),
          ),
          Spacing.md.vertical,
          SimButton(label: acaoLabel, icon: acaoIcone, height: 44, onPressed: onAcao),
        ],
      ),
    );
  }
}
