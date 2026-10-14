import 'package:core/core.dart';
import 'package:flutter/material.dart';

enum HomeAtalho {
  clientes('Clientes', Icons.groups_outlined),
  materiais('Materiais', Icons.category_outlined),
  desenhos('Desenhos', Icons.architecture),
  maquinas('Máquinas', Icons.precision_manufacturing_outlined);

  const HomeAtalho(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Atalhos para os cadastros mais usados.
class HomeAtalhosCard extends StatelessWidget {
  const HomeAtalhosCard({required this.onAtalho, super.key});

  final ValueChanged<HomeAtalho> onAtalho;

  @override
  Widget build(BuildContext context) {
    return SimCard(
      titulo: 'Acesso rápido',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final espaco = Spacing.xs.width;
          final largura = (constraints.maxWidth - espaco) / 2;
          return Wrap(
            spacing: espaco,
            runSpacing: espaco,
            children: [
              for (final atalho in HomeAtalho.values)
                SizedBox(
                  width: largura,
                  child: _BotaoAtalho(atalho: atalho, onTap: () => onAtalho(atalho)),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BotaoAtalho extends StatelessWidget {
  const _BotaoAtalho({required this.atalho, required this.onTap});

  final HomeAtalho atalho;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final raio = BorderRadius.circular(SimTokens.roundedSm);
    return Material(
      color: SimTokens.colorNeutral50,
      shape: RoundedRectangleBorder(
        borderRadius: raio,
        side: const BorderSide(color: SimTokens.colorNeutral200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: raio,
        hoverColor: SimTokens.colorPrimary50,
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              Spacing.xs.horizontal,
              Spacing.xxs.horizontal,
              Icon(atalho.icon, size: 20, color: SimTokens.colorPrimary500),
              Spacing.xs.horizontal,
              Expanded(
                child: Text(atalho.label, style: SimTypography.bodySmMedium, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
