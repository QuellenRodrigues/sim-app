import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Barra do topo: busca global, notificações e ação principal.
class MenuBarraSuperior extends StatelessWidget {
  const MenuBarraSuperior({
    required this.onBuscar,
    required this.onNotificacoes,
    required this.onNovaEncomenda,
    super.key,
  });

  final ValueChanged<String> onBuscar;
  final VoidCallback onNotificacoes;
  final VoidCallback onNovaEncomenda;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.width, vertical: Spacing.sm.height),
      decoration: const BoxDecoration(
        color: SimTokens.colorWhite,
        border: Border(bottom: BorderSide(color: SimTokens.colorBorder)),
      ),
      child: Row(
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: TextField(
                onSubmitted: onBuscar,
                textInputAction: TextInputAction.search,
                style: SimTypography.bodySmRegular,
                decoration: InputDecoration(
                  hintText: 'Buscar encomenda, cliente ou desenho',
                  fillColor: SimTokens.colorNeutral50,
                  constraints: const BoxConstraints(minHeight: 44),
                  prefixIcon: const Icon(Icons.search, size: 20, color: SimTokens.colorNeutral500),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SimTokens.roundedSm + 2),
                    borderSide: const BorderSide(color: SimTokens.colorNeutral200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SimTokens.roundedSm + 2),
                    borderSide: const BorderSide(color: SimTokens.colorPrimary500, width: SimTokens.borderMd),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Spacing.xs.horizontal,
          IconButton.outlined(
            tooltip: 'Notificações',
            onPressed: onNotificacoes,
            style: IconButton.styleFrom(
              fixedSize: const Size.square(44),
              side: const BorderSide(color: SimTokens.colorBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SimTokens.roundedSm + 2)),
            ),
            icon: const Icon(Icons.notifications_none, color: SimTokens.colorNeutral600),
          ),
          Spacing.xs.horizontal,
          SimButton(
            label: 'Nova encomenda',
            icon: Icons.add,
            height: 44,
            onPressed: onNovaEncomenda,
          ),
        ],
      ),
    );
  }
}
