import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Ícone e texto centralizados, para listas vazias e erros de carregamento.
class SimMensagem extends StatelessWidget {
  const SimMensagem({required this.icone, required this.texto, super.key, this.acao});

  final IconData icone;
  final String texto;
  final Widget? acao;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Spacing.md.width),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 32, color: SimTokens.colorNeutral400),
            Spacing.xs.vertical,
            Text(
              texto,
              textAlign: TextAlign.center,
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral600),
            ),
            if (acao != null) ...[Spacing.sm.vertical, acao!],
          ],
        ),
      ),
    );
  }
}
