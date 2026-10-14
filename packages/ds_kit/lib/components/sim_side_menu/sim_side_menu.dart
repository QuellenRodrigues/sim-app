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
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
}

/// Menu lateral de navegação do SIM.
///
/// Em [compacto], mostra só os ícones (com tooltip) — use em telas médias.
///
/// ```dart
/// SimSideMenu(
///   header: const SimLogo(height: 28),
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
    final paddingH = compacto ? Spacing.xs.width : Spacing.sm.width;

    return Container(
      width: compacto ? larguraCompacta : larguraExpandida,
      decoration: const BoxDecoration(
        color: SimTokens.colorWhite,
        border: Border(right: BorderSide(color: SimTokens.colorNeutral200)),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null)
              Container(
                height: 72,
                alignment: compacto ? Alignment.center : Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: compacto ? 0 : Spacing.md.width),
                child: header,
              ),
            Spacing.xs.vertical,
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: paddingH),
                itemCount: items.length,
                separatorBuilder: (_, _) => Spacing.xxs.vertical,
                itemBuilder: (context, index) {
                  return _SimSideMenuItem(
                    option: items[index],
                    selected: index == currentIndex,
                    compacto: compacto,
                    onTap: () => onChanged(index),
                  );
                },
              ),
            ),
            if (footer != null) ...[
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: Spacing.xs.height),
                child: footer,
              ),
            ],
          ],
        ),
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
    final corConteudo = selected ? SimTokens.colorPrimary900 : SimTokens.colorNeutral600;
    final icone = Icon(
      selected ? (option.selectedIcon ?? option.icon) : option.icon,
      size: 22,
      color: selected ? SimTokens.colorPrimary500 : SimTokens.colorNeutral500,
    );

    final item = Material(
      color: selected ? SimTokens.colorPrimary100 : SimTokens.transparent,
      borderRadius: BorderRadius.circular(SimTokens.roundedSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SimTokens.roundedSm),
        hoverColor: SimTokens.colorNeutral100,
        child: SizedBox(
          height: 44,
          child: compacto
              ? Center(child: icone)
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spacing.xs.width + 4),
                  child: Row(
                    children: [
                      icone,
                      Spacing.xs.horizontal,
                      Spacing.xxs.horizontal,
                      Expanded(
                        child: Text(
                          option.label,
                          overflow: TextOverflow.ellipsis,
                          style: (selected ? SimTypography.bodySmSemiBold : SimTypography.bodySmMedium)
                              .copyWith(color: corConteudo),
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
