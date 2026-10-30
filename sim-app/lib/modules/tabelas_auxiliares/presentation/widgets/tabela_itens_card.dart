import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../views/tabelas_auxiliares/tabelas_auxiliares_state.dart';

/// Itens da tabela escolhida, com busca e ações de incluir, editar e excluir.
class TabelaItensCard extends StatelessWidget {
  const TabelaItensCard({
    required this.state,
    required this.onBuscar,
    required this.onAdicionar,
    required this.onEditar,
    required this.onExcluir,
    required this.onTentarNovamente,
    super.key,
  });

  final TabelasAuxiliaresState state;
  final ValueChanged<String> onBuscar;
  final VoidCallback onAdicionar;
  final ValueChanged<ItemTabelaModel> onEditar;
  final ValueChanged<ItemTabelaModel> onExcluir;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    final tabela = state.tabela;
    final total = state.itens.length;

    return Container(
      decoration: BoxDecoration(
        color: SimTokens.colorWhite,
        borderRadius: BorderRadius.circular(SimTokens.roundedLg),
        border: Border.all(color: SimTokens.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(Spacing.md.width, Spacing.sm.height, Spacing.md.width, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isLoading ? 'CARREGANDO…' : (total == 1 ? '1 ITEM' : '$total ITENS'),
                  style: SimTypography.overlineSemiBold.copyWith(color: SimTokens.colorNeutral500),
                ),
                Text(tabela.titulo, style: SimTypography.titleLgMedium),
                Text(
                  tabela.descricao,
                  style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Spacing.sm.width),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    // Recria o campo ao trocar de tabela, para limpar o texto da busca.
                    key: ValueKey(tabela),
                    onChanged: onBuscar,
                    textInputAction: TextInputAction.search,
                    style: SimTypography.bodySmRegular,
                    decoration: InputDecoration(
                      hintText: 'Buscar em ${tabela.titulo.toLowerCase()}',
                      constraints: const BoxConstraints(minHeight: 44),
                      prefixIcon: const Icon(Icons.search, size: 20, color: SimTokens.colorNeutral500),
                    ),
                  ),
                ),
                Spacing.xs.horizontal,
                SimButton(label: 'Adicionar', icon: Icons.add, height: 44, onPressed: onAdicionar),
              ],
            ),
          ),
          const Divider(),
          Expanded(child: _conteudo()),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (state.erro != null) {
      return _Mensagem(
        icone: Icons.cloud_off_outlined,
        texto: state.erro!,
        acao: SimButton(
          label: 'Tentar novamente',
          style: SimButtonStyle.secundario,
          onPressed: onTentarNovamente,
        ),
      );
    }
    final itens = state.itensFiltrados;
    if (itens.isEmpty) {
      if (state.isLoading) return const Center(child: SimCircularLoading());
      return _Mensagem(
        icone: state.busca.isEmpty ? Icons.playlist_add : Icons.search_off,
        texto: state.busca.isEmpty ? 'Nenhum item cadastrado ainda.' : 'Nenhum item encontrado.',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: Spacing.xs.width, vertical: Spacing.xs.height),
      itemCount: itens.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 12, endIndent: 12),
      itemBuilder: (context, index) {
        final item = itens[index];
        return _LinhaItem(
          item: item,
          onEditar: () => onEditar(item),
          onExcluir: () => onExcluir(item),
        );
      },
    );
  }
}

class _LinhaItem extends StatelessWidget {
  const _LinhaItem({required this.item, required this.onEditar, required this.onExcluir});

  final ItemTabelaModel item;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEditar,
      borderRadius: BorderRadius.circular(SimTokens.roundedSm),
      hoverColor: SimTokens.colorNeutral50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Text(
                item.codigoFormatado,
                style: SimTypography.bodyXsRegular.copyWith(color: SimTokens.colorNeutral500),
              ),
            ),
            Expanded(
              child: Text(
                item.descricao,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SimTypography.bodySmRegular,
              ),
            ),
            IconButton(
              tooltip: 'Editar',
              onPressed: onEditar,
              icon: const Icon(Icons.edit_outlined, size: 18, color: SimTokens.colorNeutral500),
            ),
            IconButton(
              tooltip: 'Excluir',
              onPressed: onExcluir,
              icon: const Icon(Icons.delete_outline, size: 18, color: SimTokens.colorNeutral500),
            ),
          ],
        ),
      ),
    );
  }
}

class _Mensagem extends StatelessWidget {
  const _Mensagem({required this.icone, required this.texto, this.acao});

  final IconData icone;
  final String texto;
  final Widget? acao;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Spacing.md.width),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 32, color: SimTokens.colorNeutral400),
            Spacing.xs.vertical,
            Text(
              texto,
              textAlign: TextAlign.center,
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral600),
            ),
            if (acao != null) ...[Spacing.sm.vertical, acao!],
          ],
        ),
      ),
    );
  }
}
