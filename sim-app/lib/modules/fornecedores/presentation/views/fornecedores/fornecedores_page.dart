import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../fornecedores.dart';

class FornecedoresPage extends StatefulWidget {
  const FornecedoresPage({super.key});

  @override
  State<FornecedoresPage> createState() => _FornecedoresPageState();
}

class _FornecedoresPageState extends ViewState<FornecedoresPage, FornecedoresViewModel> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _suspender(FornecedoresState state) async {
    final fornecedor = state.selecionado;
    if (fornecedor == null) return;

    if (!fornecedor.suspenso) {
      final confirmou = await SimDialog.confirmar(
        context,
        titulo: 'Suspender fornecedor?',
        mensagem:
            '"${fornecedor.razaoSocial}" fica marcado como suspenso. '
            'Você pode retirar a suspensão quando quiser.',
        textoConfirmar: 'Suspender',
      );
      if (!confirmou) return;
    }
    await viewModel.alternarSuspensao();
  }

  Future<void> _adicionarMateriais() async {
    final disponiveis = await viewModel.materiaisDisponiveis();
    if (disponiveis == null || !mounted) return;

    final codigos = await MateriaisFornecedorDialog.mostrar(context, disponiveis: disponiveis);
    if (codigos != null) await viewModel.adicionarMateriais(codigos);
  }

  /// Remover o material apaga os preços dele, por isso pede confirmação só nesse caso.
  Future<void> _removerMaterial(FornecedoresState state, MaterialFornecidoModel material) async {
    final precos = state.precos.where((p) => p.material == material).length;
    if (precos > 0) {
      final confirmou = await SimDialog.confirmar(
        context,
        titulo: 'Remover material?',
        mensagem: precos == 1
            ? '"${material.nome}" tem 1 preço informado, que também será removido.'
            : '"${material.nome}" tem $precos preços informados, que também serão removidos.',
        textoConfirmar: 'Remover',
        destrutivo: true,
      );
      if (!confirmou) return;
    }
    await viewModel.removerMaterial(material);
  }

  Future<void> _editarPreco(FornecedoresState state, [PrecoMaterialModel? preco]) {
    return PrecoMaterialDialog.mostrar(
      context,
      codigoFornecedor: state.selecionado!.codigo!,
      materiais: state.materiais,
      preco: preco,
      onSalvar: (novo) => viewModel.salvarPreco(novo),
    );
  }

  Future<void> _excluirPreco(PrecoMaterialModel preco) async {
    final confirmou = await SimDialog.confirmar(
      context,
      titulo: 'Excluir preço?',
      mensagem: 'O preço de "${preco.nomeItem}" sai da consulta de preços.',
      textoConfirmar: 'Excluir',
      destrutivo: true,
    );
    if (confirmou) await viewModel.excluirPreco(preco);
  }

  @override
  Widget build(BuildContext context) {
    return SimScaffold(
      body: ViewModelConsumer<FornecedoresViewModel, FornecedoresState>(
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
                FornecedoresCabecalho(
                  total: state.fornecedores.length,
                  onNovo: () => viewModel.novo(),
                  onConsultarPrecos: () => Nav.navigate(PrecosConsultaPage.rota),
                ),
                Spacing.md.vertical,
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 900) {
                        return state.modo == FornecedoresModo.nenhum
                            ? _lista(state)
                            : _formulario(state, onVoltar: () => viewModel.fechar());
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 360, child: _lista(state)),
                          Spacing.md.horizontal,
                          Expanded(
                            child: state.modo == FornecedoresModo.nenhum
                                ? SimPainelVazio(
                                    icone: Icons.local_shipping_outlined,
                                    titulo: 'Selecione um fornecedor',
                                    texto:
                                        'Escolha um fornecedor na lista para ver e editar os dados, ou cadastre um novo.',
                                    acaoLabel: 'Novo fornecedor',
                                    acaoIcone: Icons.add_business_outlined,
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

  Widget _lista(FornecedoresState state) {
    return FornecedoresLista(
      fornecedores: state.fornecedores,
      isLoading: state.isLoading,
      erro: state.erroLista,
      codigoSelecionado: state.modo == FornecedoresModo.edicao ? state.selecionado?.codigo : null,
      onBuscar: (texto) => viewModel.buscar(texto),
      onSelecionar: (fornecedor) => viewModel.selecionar(fornecedor),
      onTentarNovamente: () => viewModel.carregar(),
    );
  }

  Widget _formulario(FornecedoresState state, {VoidCallback? onVoltar}) {
    return FornecedorFormulario(
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
      onSuspender: () => _suspender(state),
      onAdicionarMateriais: _adicionarMateriais,
      onRemoverMaterial: (material) => _removerMaterial(state, material),
      onAdicionarPreco: () => _editarPreco(state),
      onEditarPreco: (preco) => _editarPreco(state, preco),
      onExcluirPreco: _excluirPreco,
    );
  }
}
