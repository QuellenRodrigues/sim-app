import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Painel direito quando nenhum cliente está aberto.
class ClientesVazio extends StatelessWidget {
  const ClientesVazio({required this.onNovo, super.key});

  final VoidCallback onNovo;

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
            child: const Icon(Icons.groups_outlined, size: 34, color: SimTokens.colorPrimary500),
          ),
          Spacing.sm.vertical,
          Text('Selecione um cliente', style: SimTypography.titleLgMedium),
          Spacing.xxs.vertical,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Text(
              'Escolha um cliente na lista para ver e editar os dados, ou cadastre um novo.',
              textAlign: TextAlign.center,
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
            ),
          ),
          Spacing.md.vertical,
          SimButton(
            label: 'Novo cliente',
            icon: Icons.person_add_alt_1_outlined,
            height: 44,
            onPressed: onNovo,
          ),
        ],
      ),
    );
  }
}
