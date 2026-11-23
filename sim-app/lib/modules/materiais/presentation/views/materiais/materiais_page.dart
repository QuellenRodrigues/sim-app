import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../materiais.dart';

class MateriaisPage extends StatefulWidget {
  const MateriaisPage({super.key});

  @override
  State<MateriaisPage> createState() => _MateriaisPageState();
}

class _MateriaisPageState extends ViewState<MateriaisPage, MateriaisViewModel> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _excluir(MateriaisState state) async {
    final confirmou = await SimDialog.confirmar(
      context,
      titulo: 'Excluir material?',
      mensagem:
          '"${state.selecionado?.nome}" sai do catálogo, com a tabela de bitolas. '
          'Orçamentos que já usam este material não são alterados.',
      textoConfirmar: 'Excluir',
      destrutivo: true,
    );
    if (confirmou) await viewModel.excluir();
  }

  Future<void> _excluirLinha(LinhaBitolaModel linha) async {
    final nome = linha.valores.where((v) => v.isNotEmpty).take(2).join(' · ');
    final confirmou = await SimDialog.confirmar(
      context,
      titulo: 'Excluir linha?',
      mensagem: 'A bitola "$nome" sai da tabela.',
      textoConfirmar: 'Excluir',
      destrutivo: true,
    );
    if (confirmou) await viewModel.excluirLinha(linha);
  }

  @override
  Widget build(BuildContext context) {
    return SimScaffold(
      body: ViewModelConsumer<MateriaisViewModel, MateriaisState>(
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
          final total = state.materiais.length;

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
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: Spacing.sm.width,
                  runSpacing: Spacing.sm.height,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('CADASTROS', style: SimTypography.overlineSemiBold),
                        Spacing.xxs.vertical,
                        Text('Materiais', style: SimTypography.titleXlMedium),
                        Text(
                          total == 1 ? '1 material cadastrado' : '$total materiais cadastrados',
                          style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
                        ),
                      ],
                    ),
                    SimButton(
                      label: 'Novo material',
                      icon: Icons.add,
                      height: 44,
                      onPressed: () => viewModel.novo(),
                    ),
                  ],
                ),
                Spacing.md.vertical,
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 900) {
                        return state.modo == MateriaisModo.nenhum
                            ? _lista(state)
                            : _formulario(state, onVoltar: () => viewModel.fechar());
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 320, child: _lista(state)),
                          Spacing.md.horizontal,
                          Expanded(
                            child: state.modo == MateriaisModo.nenhum
                                ? SimPainelVazio(
                                    icone: Icons.view_in_ar_outlined,
                                    titulo: 'Selecione um material',
                                    texto:
                                        'Escolha um material na lista para ver os dados e a tabela de bitolas.',
                                    acaoLabel: 'Novo material',
                                    acaoIcone: Icons.add,
                                    onAcao: () => viewModel.novo(),
                                  )
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

  Widget _lista(MateriaisState state) {
    return MateriaisLista(
      materiais: state.materiais,
      isLoading: state.isLoading,
      erro: state.erroLista,
      codigoSelecionado: state.modo == MateriaisModo.edicao ? state.selecionado?.codigo : null,
      onBuscar: (texto) => viewModel.buscar(texto),
      onSelecionar: (material) => viewModel.selecionar(material),
      onTentarNovamente: () => viewModel.carregar(),
    );
  }

  Widget _formulario(MateriaisState state, {VoidCallback? onVoltar}) {
    return MaterialFormulario(
      formKey: _formKey,
      viewModel: viewModel,
      state: state,
      onVoltar: onVoltar,
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
      onEditarColunas: () => ColunasTabelaDialog.mostrar(
        context,
        tabela: state.tabela,
        onSalvar: viewModel.salvarEstrutura,
      ),
      onAdicionarLinha: () => LinhaBitolaDialog.mostrar(
        context,
        colunas: state.tabela.colunas,
        onSalvar: viewModel.salvarLinha,
      ),
      onEditarLinha: (linha) => LinhaBitolaDialog.mostrar(
        context,
        colunas: state.tabela.colunas,
        linha: linha,
        onSalvar: viewModel.salvarLinha,
      ),
      onExcluirLinha: _excluirLinha,
    );
  }
}
