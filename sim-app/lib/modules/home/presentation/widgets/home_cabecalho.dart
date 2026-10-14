import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Saudação, data de hoje e ações principais da home.
class HomeCabecalho extends StatelessWidget {
  const HomeCabecalho({
    required this.saudacao,
    required this.dataHoje,
    required this.onNovoOrcamento,
    required this.onNovaEncomenda,
    super.key,
  });

  final String saudacao;
  final String dataHoje;
  final VoidCallback onNovoOrcamento;
  final VoidCallback onNovaEncomenda;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: Spacing.sm.width,
      runSpacing: Spacing.sm.height,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(dataHoje, style: SimTypography.bodySmMedium.copyWith(color: SimTokens.colorNeutral500)),
            Spacing.xxs.vertical,
            Text(saudacao.isEmpty ? '' : '$saudacao!', style: SimTypography.titleXlMedium),
            Text(
              'Este é o resumo da produção de hoje.',
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral600),
            ),
          ],
        ),
        Wrap(
          spacing: Spacing.xs.width,
          runSpacing: Spacing.xs.height,
          children: [
            SimButton(
              label: 'Nova encomenda',
              icon: Icons.add,
              style: SimButtonStyle.secundario,
              onPressed: onNovaEncomenda,
            ),
            SimButton(
              label: 'Novo orçamento',
              icon: Icons.request_quote_outlined,
              onPressed: onNovoOrcamento,
            ),
          ],
        ),
      ],
    );
  }
}
