import 'package:flutter/material.dart';

import '../../theme/spacing/spacing.dart';
import '../../theme/tokens/tokens.dart';
import '../../theme/typography/sim_typography.dart';

/// Item do [SimSideMenu].
class SimMenuOption {
  const SimMenuOption({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.secao,
    this.badge,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;

  /// Grupo do item; um título é exibido quando a seção muda.
  final String? secao;

  /// Contador opcional à direita do rótulo.
  final int? badge;
}

/// Menu lateral escuro de navegação do SIM.
///
/// Em [compacto], mostra só os ícones (com tooltip) — use em telas médias.
///
/// ```dart
/// SimSideMenu(
///   header: const SimLogo(height: 28, negativo: true),
///   currentIndex: state.currentIndex,
///   items: [...],
///   onChanged: (index) => viewModel.selecionar(index),
/// )
/// ```
class SimSideMenu extends StatelessWidget {
  const SimSideMenu({
    required this.items,
    required this.currentIndex,
    required this.onChanged,
    super.key,
    this.header,
    this.footer,
    this.compacto = false,
  });

  final List<SimMenuOption> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final Widget? header;
  final Widget? footer;
  final bool compacto;

  static const double larguraExpandida = 248;
  static const double larguraCompacta = 76;

  @override
  Widget build(BuildContext context) {
    final paddingH = compacto ? Spacing.xs.width + 2 : Spacing.sm.width;
    final filhos = <Widget>[];
    String? secaoAtual;

    for (final (index, item) in items.indexed) {
      if (item.secao != null && item.secao != secaoAtual) {
        filhos.add(_TituloSecao(titulo: item.secao!, compacto: compacto));
      }
      secaoAtual = item.secao;
      filhos.add(
        Padding(
          padding: EdgeInsets.only(bottom: Spacing.xxs.height),
          child: _SimSideMenuItem(
            option: item,
            selected: index == currentIndex,
            compacto: compacto,
            onTap: () => onChanged(index),
          ),
        ),
      );
    }

    return Container(
      width: compacto ? larguraCompacta : larguraExpandida,
      color: SimTokens.colorSidebar,
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null)
              Container(
                height: 80,
                alignment: compacto ? Alignment.center : Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: compacto ? 0 : Spacing.md.width - 2),
                child: header,
              ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: paddingH),
                children: filhos,
              ),
            ),
            if (footer != null)
              Padding(
                padding: EdgeInsets.fromLTRB(paddingH, Spacing.sm.height, paddingH, Spacing.sm.height),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}

class _TituloSecao extends StatelessWidget {
  const _TituloSecao({required this.titulo, required this.compacto});

  final String titulo;
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    if (compacto) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: Spacing.xs.height, horizontal: Spacing.xs.width),
        child: const Divider(color: SimTokens.colorSidebarBorder),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 6),
      child: Text(
        titulo.toUpperCase(),
        style: SimTypography.labelXsSemiBold.copyWith(color: SimTokens.colorSidebarLabel, letterSpacing: 0.9),
      ),
    );
  }
}

class _SimSideMenuItem extends StatelessWidget {
  const _SimSideMenuItem({
    required this.option,
    required this.selected,
    required this.compacto,
    required this.onTap,
  });

  final SimMenuOption option;
  final bool selected;
  final bool compacto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cor = selected ? SimTokens.colorWhite : SimTokens.colorSidebarText;
    final icone = Icon(selected ? (option.selectedIcon ?? option.icon) : option.icon, size: 20, color: cor);
    final raio = BorderRadius.circular(SimTokens.roundedSm + 2);

    final item = Material(
      color: selected ? SimTokens.colorPrimary500 : SimTokens.transparent,
      borderRadius: raio,
      child: InkWell(
        onTap: onTap,
        borderRadius: raio,
        hoverColor: SimTokens.colorSidebarSurface,
        child: SizedBox(
          height: 44,
          child: compacto
              ? Center(child: icone)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      icone,
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option.label,
                          overflow: TextOverflow.ellipsis,
                          style: (selected ? SimTypography.bodySmSemiBold : SimTypography.bodySmMedium)
                              .copyWith(color: cor),
                        ),
                      ),
                      if (option.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: selected ? SimTokens.colorPrimary700 : SimTokens.colorSidebarBorder,
                            borderRadius: BorderRadius.circular(SimTokens.roundedMax),
                          ),
                          child: Text(
                            '${option.badge}',
                            style: SimTypography.labelSmMedium.copyWith(
                              color: cor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: option.label,
      child: compacto ? Tooltip(message: option.label, preferBelow: false, child: item) : item,
    );
  }
}
