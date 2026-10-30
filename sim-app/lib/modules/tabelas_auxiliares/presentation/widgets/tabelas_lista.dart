import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Lista das tabelas auxiliares, agrupadas pela área do sistema que as usa.
class TabelasLista extends StatelessWidget {
  const TabelasLista({required this.selecionada, required this.onSelecionar, super.key});

  final TabelaAuxiliar selecionada;
  final ValueChanged<TabelaAuxiliar> onSelecionar;

  @override
  Widget build(BuildContext context) {
    final areas = <String, List<TabelaAuxiliar>>{};
    for (final tabela in TabelaAuxiliar.values) {
      areas.putIfAbsent(tabela.area, () => []).add(tabela);
    }

    return Container(
      decoration: BoxDecoration(
        color: SimTokens.colorWhite,
        borderRadius: BorderRadius.circular(SimTokens.roundedLg),
        border: Border.all(color: SimTokens.colorBorder),
      ),
      child: ListView(
        padding: EdgeInsets.all(Spacing.xs.width),
        children: [
          for (final (i, MapEntry(key: area, value: tabelas)) in areas.entries.indexed) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(12, i == 0 ? 8 : 16, 12, 6),
              child: Text(area.toUpperCase(), style: SimTypography.labelXsSemiBold),
            ),
            for (final tabela in tabelas)
              _ItemTabela(
                tabela: tabela,
                selecionada: tabela == selecionada,
                onTap: () => onSelecionar(tabela),
              ),
          ],
        ],
      ),
    );
  }
}

class _ItemTabela extends StatelessWidget {
  const _ItemTabela({required this.tabela, required this.selecionada, required this.onTap});

  final TabelaAuxiliar tabela;
  final bool selecionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final raio = BorderRadius.circular(SimTokens.roundedMd);

    return Semantics(
      selected: selecionada,
      button: true,
      child: Material(
        color: selecionada ? SimTokens.colorPrimary50 : SimTokens.transparent,
        shape: RoundedRectangleBorder(borderRadius: raio),
        child: InkWell(
          onTap: onTap,
          borderRadius: raio,
          hoverColor: SimTokens.colorNeutral50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tabela.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: selecionada
                        ? SimTypography.bodySmSemiBold.copyWith(color: SimTokens.colorPrimary900)
                        : SimTypography.bodySmRegular,
                  ),
                ),
                if (selecionada) const Icon(Icons.chevron_right, size: 20, color: SimTokens.colorPrimary500),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
