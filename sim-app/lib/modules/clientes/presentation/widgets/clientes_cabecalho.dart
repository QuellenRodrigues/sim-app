import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Título da tela, total de clientes e ação de cadastrar.
class ClientesCabecalho extends StatelessWidget {
  const ClientesCabecalho({
    required this.total,
    required this.onNovo,
    super.key,
  });

  final int total;
  final VoidCallback onNovo;

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
            Text('Clientes', style: SimTypography.titleXlMedium),
            Text(
              total == 1 ? '1 cliente cadastrado' : '${NumberFormatter.inteiro(total)} clientes cadastrados',
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
            ),
          ],
        ),
        SimButton(
          label: 'Novo cliente',
          icon: Icons.person_add_alt_1_outlined,
          height: 44,
          onPressed: onNovo,
        ),
      ],
    );
  }
}
