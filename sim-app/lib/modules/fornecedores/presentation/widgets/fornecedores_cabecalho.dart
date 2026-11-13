import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Título da tela, total de fornecedores e ação de cadastrar.
class FornecedoresCabecalho extends StatelessWidget {
  const FornecedoresCabecalho({
    required this.total,
    required this.onNovo,
    required this.onConsultarPrecos,
    super.key,
  });

  final int total;
  final VoidCallback onNovo;
  final VoidCallback onConsultarPrecos;

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
            Text('CADASTROS', style: SimTypography.overlineSemiBold),
            Spacing.xxs.vertical,
            Text('Fornecedores', style: SimTypography.titleXlMedium),
            Text(
              total == 1
                  ? '1 fornecedor cadastrado'
                  : '${NumberFormatter.inteiro(total)} fornecedores cadastrados',
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
            ),
          ],
        ),
        Wrap(
          spacing: Spacing.xs.width,
          runSpacing: Spacing.xs.height,
          children: [
            SimButton(
              label: 'Consultar preços',
              icon: Icons.price_check,
              style: SimButtonStyle.secundario,
              height: 44,
              onPressed: onConsultarPrecos,
            ),
            SimButton(
              label: 'Novo fornecedor',
              icon: Icons.add_business_outlined,
              height: 44,
              onPressed: onNovo,
            ),
          ],
        ),
      ],
    );
  }
}
