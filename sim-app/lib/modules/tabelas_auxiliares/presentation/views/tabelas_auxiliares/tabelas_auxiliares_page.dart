import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../tabelas_auxiliares.dart';

class TabelasAuxiliaresPage extends StatefulWidget {
  const TabelasAuxiliaresPage({super.key});

  @override
  State<TabelasAuxiliaresPage> createState() => _TabelasAuxiliaresPageState();
}

class _TabelasAuxiliaresPageState extends ViewState<TabelasAuxiliaresPage, TabelasAuxiliaresViewModel> {
  Future<void> _editar(TabelasAuxiliaresState state, [ItemTabelaModel? item]) {
    return ItemTabelaDialog.mostrar(
      context,
      tabela: state.tabela,
      item: item,
      onSalvar: (descricao) => viewModel.salvar(descricao: descricao, codigo: item?.codigo),
    );
  }

  Future<void> _excluir(ItemTabelaModel item) async {
    final confirmou = await SimDialog.confirmar(
      context,
      titulo: 'Excluir item?',
      mensagem:
          '"${item.descricao}" deixa de aparecer nas listas. '
          'Orçamentos e lançamentos que já usam este item não são alterados.',
      textoConfirmar: 'Excluir',
      destrutivo: true,
    );
    if (confirmou) await viewModel.excluir(item);
  }

  @override
  Widget build(BuildContext context) {
    return SimScaffold(
      body: ViewModelConsumer<TabelasAuxiliaresViewModel, TabelasAuxiliaresState>(
        viewModel: viewModel,
        listenWhen: (anterior, atual) => atual.aviso != null && anterior.aviso != atual.aviso,
        listener: (context, state) {
          final aviso = state.aviso!;
          SimSnackBar(
            message: aviso.texto,
            type: aviso.sucesso ? SimSnackBarType.success : SimSnackBarType.error,
          ).show(context);
        },
        builder: (context, state) {
          final compacto = context.screenWidth < SimBreakpoints.compacto;

          final itens = TabelaItensCard(
            state: state,
            onBuscar: (texto) => viewModel.buscar(texto),
            onAdicionar: () => _editar(state),
            onEditar: (item) => _editar(state, item),
            onExcluir: _excluir,
            onTentarNovamente: () => viewModel.carregar(),
          );

          return Padding(
            padding: EdgeInsets.fromLTRB(
              compacto ? Spacing.sm.width : Spacing.lg.width,
              compacto ? Spacing.sm.height : Spacing.md.height + 4,
              compacto ? Spacing.sm.width : Spacing.lg.width,
              compacto ? Spacing.sm.height : Spacing.md.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('CADASTROS', style: SimTypography.overlineSemiBold),
                Spacing.xxs.vertical,
                Text('Tabelas auxiliares', style: SimTypography.titleXlMedium),
                Text(
                  'Listas usadas para preencher os outros cadastros, orçamentos e o almoxarifado.',
                  style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
                ),
                Spacing.md.vertical,
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 900) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SimDropdownField<TabelaAuxiliar>(
                              label: 'Tabela',
                              valor: state.tabela,
                              itens: {for (final t in TabelaAuxiliar.values) t: '${t.area} · ${t.titulo}'},
                              onChanged: (tabela) => viewModel.selecionarTabela(tabela!),
                            ),
                            Spacing.sm.vertical,
                            Expanded(child: itens),
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 280,
                            child: TabelasLista(
                              selecionada: state.tabela,
                              onSelecionar: (tabela) => viewModel.selecionarTabela(tabela),
                            ),
                          ),
                          Spacing.md.horizontal,
                          Expanded(child: itens),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
