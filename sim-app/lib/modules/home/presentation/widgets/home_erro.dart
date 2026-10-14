import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Estado de erro ao carregar o painel, com opção de tentar de novo.
class HomeErro extends StatelessWidget {
  const HomeErro({
    required this.mensagem,
    required this.onTentarNovamente,
    super.key,
  });

  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return SimCard(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Spacing.lg.height),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40, color: SimTokens.colorNeutral400),
            Spacing.sm.vertical,
            Text(mensagem, textAlign: TextAlign.center, style: SimTypography.bodyMdRegular),
            Spacing.sm.vertical,
            SimButton(
              label: 'Tentar novamente',
              icon: Icons.refresh,
              style: SimButtonStyle.secundario,
              onPressed: onTentarNovamente,
            ),
          ],
        ),
      ),
    );
  }
}
