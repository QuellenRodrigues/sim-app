import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Ações fixas no rodapé do menu lateral.
class MenuRodape extends StatelessWidget {
  const MenuRodape({
    required this.compacto,
    required this.onConfiguracoes,
    super.key,
  });

  final bool compacto;
  final VoidCallback onConfiguracoes;

  @override
  Widget build(BuildContext context) {
    if (compacto) {
      return IconButton(
        tooltip: 'Configurações',
        onPressed: onConfiguracoes,
        icon: const Icon(Icons.settings_outlined),
      );
    }

    return TextButton.icon(
      onPressed: onConfiguracoes,
      style: TextButton.styleFrom(
        foregroundColor: SimTokens.colorNeutral600,
        alignment: Alignment.centerLeft,
        minimumSize: const Size.fromHeight(44),
        padding: EdgeInsets.symmetric(horizontal: Spacing.xs.width + 4),
      ),
      icon: const Icon(Icons.settings_outlined, size: 22),
      label: Text(
        'Configurações',
        style: SimTypography.bodySmMedium.copyWith(color: SimTokens.colorNeutral600),
      ),
    );
  }
}
