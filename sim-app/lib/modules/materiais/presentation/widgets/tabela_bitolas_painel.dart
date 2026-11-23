import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../views/materiais/materiais_state.dart';

/// Tabela de bitolas do material: colunas definidas por material e linhas na ordem do orçamento.
/// As alterações são gravadas na hora, como no sistema antigo.
class TabelaBitolasPainel extends StatelessWidget {
  const TabelaBitolasPainel({
    required this.state,
    required this.onBuscar,
    required this.onEditarColunas,
    required this.onAdicionarLinha,
    required this.onEditarLinha,
    required this.onExcluirLinha,
    required this.onMoverLinha,
    required this.onTentarNovamente,
    super.key,
  });

  final MateriaisState state;
  final ValueChanged<String> onBuscar;
  final VoidCallback onEditarColunas;
  final VoidCallback onAdicionarLinha;
  final ValueChanged<LinhaBitolaModel> onEditarLinha;
  final ValueChanged<LinhaBitolaModel> onExcluirLinha;
  final void Function(LinhaBitolaModel linha, int deslocamento) onMoverLinha;
  final VoidCallback onTentarNovamente;

  static const _larguraColuna = 128.0;
  static const _larguraAcoes = 48.0;

  @override
  Widget build(BuildContext context) {
    final tabela = state.tabela;

    if (state.erroTabela != null) {
      return SimMensagem(
        icone: Icons.cloud_off_outlined,
        texto: state.erroTabela!,
        acao: SimButton(
          label: 'Tentar novamente',
          style: SimButtonStyle.secundario,
          onPressed: onTentarNovamente,
        ),
      );
    }
    if (state.carregandoTabela && !tabela.temColunas) {
      return const Center(child: SimCircularLoading());
    }
    if (!tabela.temColunas) {
      return SimMensagem(
        icone: Icons.table_chart_outlined,
        texto:
            'Este material ainda não tem tabela de bitolas.\nDefina as colunas, como "Bitola pol.", "Bitola mm" e "Peso kg/m".',
        acao: SimButton(
          label: 'Definir colunas',
          icon: Icons.view_column_outlined,
          onPressed: onEditarColunas,
        ),
      );
    }

    final linhas = state.linhasFiltradas;
    final filtrando = state.buscaTabela.trim().isNotEmpty;
    final larguraTabela = tabela.colunas.length * _larguraColuna + _larguraAcoes + 12;
    final detalhe = [
      if (tabela.nome.isNotEmpty) tabela.nome,
      'Unidade: ${tabela.unidade.descricao}',
      tabela.linhas.length == 1 ? '1 linha' : '${tabela.linhas.length} linhas',
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(Spacing.md.width, Spacing.sm.height, Spacing.md.width, 0),
          child: Wrap(
            spacing: Spacing.xs.width,
            runSpacing: Spacing.xs.height,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: TextField(
                  onChanged: onBuscar,
                  textInputAction: TextInputAction.search,
                  style: SimTypography.bodySmRegular,
                  decoration: const InputDecoration(
                    hintText: 'Buscar bitola',
                    constraints: BoxConstraints(minHeight: 44),
                    prefixIcon: Icon(Icons.search, size: 20, color: SimTokens.colorNeutral500),
                  ),
                ),
              ),
              SimButton(
                label: 'Colunas',
                icon: Icons.view_column_outlined,
                style: SimButtonStyle.secundario,
                height: 44,
                onPressed: onEditarColunas,
              ),
              SimButton(label: 'Adicionar linha', icon: Icons.add, height: 44, onPressed: onAdicionarLinha),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            Spacing.md.width,
            Spacing.xs.height,
            Spacing.md.width,
            Spacing.xs.height,
          ),
          child: Text(detalhe, style: SimTypography.bodyXsRegular),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final largura = larguraTabela > constraints.maxWidth ? larguraTabela : constraints.maxWidth;
              return Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: largura,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Cabecalho(colunas: tabela.colunas),
                        const Divider(height: 1),
                        Expanded(
                          child: linhas.isEmpty
                              ? SimMensagem(
                                  icone: filtrando ? Icons.search_off : Icons.playlist_add,
                                  texto: filtrando ? 'Nenhuma bitola encontrada.' : 'Nenhuma linha ainda.',
                                )
                              : ListView.separated(
                                  itemCount: linhas.length,
                                  separatorBuilder: (_, _) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final linha = linhas[index];
                                    final posicao = tabela.linhas.indexOf(linha);
                                    return _Linha(
                                      linha: linha,
                                      colunas: tabela.colunas.length,
                                      bitola: state.colunaBitola,
                                      podeSubir: !filtrando && posicao > 0,
                                      podeDescer: !filtrando && posicao < tabela.linhas.length - 1,
                                      onEditar: () => onEditarLinha(linha),
                                      onExcluir: () => onExcluirLinha(linha),
                                      onMover: (deslocamento) => onMoverLinha(linha, deslocamento),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho({required this.colunas});

  final List<String> colunas;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SimTokens.colorNeutral50,
      padding: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
      child: Row(
        children: [
          const SizedBox(width: TabelaBitolasPainel._larguraAcoes),
          for (final coluna in colunas)
            SizedBox(
              width: TabelaBitolasPainel._larguraColuna,
              child: Text(
                coluna.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: SimTypography.labelXsSemiBold,
              ),
            ),
        ],
      ),
    );
  }
}

enum _AcaoLinha { editar, subir, descer, excluir }

class _Linha extends StatelessWidget {
  const _Linha({
    required this.linha,
    required this.colunas,
    required this.bitola,
    required this.podeSubir,
    required this.podeDescer,
    required this.onEditar,
    required this.onExcluir,
    required this.onMover,
  });

  final LinhaBitolaModel linha;
  final int colunas;

  /// Coluna destacada por ser a que o orçamento usa como bitola.
  final int? bitola;
  final bool podeSubir;
  final bool podeDescer;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;
  final ValueChanged<int> onMover;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEditar,
      hoverColor: SimTokens.colorNeutral50,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Row(
          children: [
            SizedBox(
              width: TabelaBitolasPainel._larguraAcoes,
              child: PopupMenuButton<_AcaoLinha>(
                tooltip: 'Ações da linha',
                icon: const Icon(Icons.more_vert, size: 18, color: SimTokens.colorNeutral500),
                onSelected: (acao) => switch (acao) {
                  _AcaoLinha.editar => onEditar(),
                  _AcaoLinha.subir => onMover(-1),
                  _AcaoLinha.descer => onMover(1),
                  _AcaoLinha.excluir => onExcluir(),
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: _AcaoLinha.editar, child: Text('Editar')),
                  PopupMenuItem(value: _AcaoLinha.subir, enabled: podeSubir, child: const Text('Subir')),
                  PopupMenuItem(value: _AcaoLinha.descer, enabled: podeDescer, child: const Text('Descer')),
                  const PopupMenuItem(value: _AcaoLinha.excluir, child: Text('Excluir')),
                ],
              ),
            ),
            for (var i = 0; i < colunas; i++)
              SizedBox(
                width: TabelaBitolasPainel._larguraColuna,
                child: Text(
                  linha.valor(i).isEmpty ? '—' : linha.valor(i),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: i == bitola ? SimTypography.bodySmSemiBold : SimTypography.bodySmRegular,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
