import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Usuário logado e acesso às configurações, no rodapé do menu lateral.
class MenuUsuarioCard extends StatelessWidget {
  const MenuUsuarioCard({
    required this.nome,
    required this.perfil,
    required this.compacto,
    required this.onConfiguracoes,
    super.key,
  });

  final String nome;
  final String perfil;
  final bool compacto;
  final VoidCallback onConfiguracoes;

  @override
  Widget build(BuildContext context) {
    final avatar = SimAvatar(
      iniciais: SimAvatar.iniciaisDe(nome),
      background: SimTokens.colorPrimary500,
      foreground: SimTokens.colorWhite,
      size: 36,
      circular: true,
    );

    final botaoConfiguracoes = IconButton(
      tooltip: 'Configurações',
      onPressed: onConfiguracoes,
      color: SimTokens.colorSidebarText,
      icon: const Icon(Icons.tune, size: 20),
    );

    if (compacto) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [botaoConfiguracoes, Spacing.xxs.vertical, avatar],
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        color: SimTokens.colorSidebarSurface,
        borderRadius: BorderRadius.circular(SimTokens.roundedMd),
      ),
      child: Row(
        children: [
          avatar,
          Spacing.xs.horizontal,
          Spacing.xxs.horizontal,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  overflow: TextOverflow.ellipsis,
                  style: SimTypography.bodySmSemiBold.copyWith(color: SimTokens.colorWhite),
                ),
                Text(
                  perfil,
                  overflow: TextOverflow.ellipsis,
                  style: SimTypography.bodyXsRegular.copyWith(color: SimTokens.colorSidebarTextMuted),
                ),
              ],
            ),
          ),
          botaoConfiguracoes,
        ],
      ),
    );
  }
}
