import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../../util/util.dart';
import '../../../clientes.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends ViewState<ClientesPage, ClientesViewModel> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _excluir(ClientesState state) async {
    final confirmou = await SimDialog.confirmar(
      context,
      titulo: 'Excluir cliente?',
      mensagem:
          'O cliente "${state.selecionado?.razaoSocial}" será removido do cadastro. Esta ação não pode ser desfeita.',
      textoConfirmar: 'Excluir',
      destrutivo: true,
    );
    if (confirmou) await viewModel.excluir();
  }

  @override
  Widget build(BuildContext context) {
    return SimScaffold(
      body: ViewModelConsumer<ClientesViewModel, ClientesState>(
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
                ClientesCabecalho(total: state.clientes.length, onNovo: () => viewModel.novo()),
                Spacing.md.vertical,
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 900) {
                        return state.modo == ClientesModo.nenhum
                            ? _lista(state)
                            : _formulario(state, onVoltar: () => viewModel.fechar());
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 360, child: _lista(state)),
                          Spacing.md.horizontal,
                          Expanded(
                            child: state.modo == ClientesModo.nenhum
                                ? ClientesVazio(onNovo: () => viewModel.novo())
                                : _formulario(state),
                          ),
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

  Widget _lista(ClientesState state) {
    return ClientesLista(
      clientes: state.clientes,
      isLoading: state.isLoading,
      erro: state.erroLista,
      codigoSelecionado: state.modo == ClientesModo.edicao ? state.selecionado?.codigo : null,
      onBuscar: (texto) => viewModel.buscar(texto),
      onSelecionar: (cliente) => viewModel.selecionar(cliente),
      onTentarNovamente: () => viewModel.carregar(),
    );
  }

  Widget _formulario(ClientesState state, {VoidCallback? onVoltar}) {
    return ClienteFormulario(
      formKey: _formKey,
      viewModel: viewModel,
      state: state,
      onVoltar: onVoltar,
      onEstado: (uf) => viewModel.alterarEstado(uf),
      onSalvar: () {
        final valido = _formKey.currentState?.validate() ?? false;
        if (!valido) {
          const SimSnackBar(
            title: 'Revise o formulário',
            message: 'Corrija os campos destacados antes de salvar.',
            type: SimSnackBarType.warning,
          ).show(context);
          return;
        }
        viewModel.salvar();
      },
      onCancelar: () => viewModel.fechar(),
      onExcluir: () => _excluir(state),
      onTaxas: () => mostrarFuncionalidadeNaoImplementada(context),
    );
  }
}
