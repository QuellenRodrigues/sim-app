import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../views/materiais/materiais_state.dart';
import '../views/materiais/materiais_viewmodel.dart';
import 'tabela_bitolas_painel.dart';

/// Material aberto: aba de dados e aba da tabela de bitolas.
class MaterialFormulario extends StatelessWidget {
  const MaterialFormulario({
    required this.formKey,
    required this.viewModel,
    required this.state,
    required this.onSalvar,
    required this.onCancelar,
    required this.onExcluir,
    required this.onEditarColunas,
    required this.onAdicionarLinha,
    required this.onEditarLinha,
    required this.onExcluirLinha,
    super.key,
    this.onVoltar,
  });

  final GlobalKey<FormState> formKey;
  final MateriaisViewModel viewModel;
  final MateriaisState state;
  final VoidCallback onSalvar;
  final VoidCallback onCancelar;
  final VoidCallback onExcluir;
  final VoidCallback onEditarColunas;
  final VoidCallback onAdicionarLinha;
  final ValueChanged<LinhaBitolaModel> onEditarLinha;
  final ValueChanged<LinhaBitolaModel> onExcluirLinha;

  /// Exibe a seta de voltar (layout de celular).
  final VoidCallback? onVoltar;

  @override
  Widget build(BuildContext context) {
    final edicao = state.modo == MateriaisModo.edicao;
    final material = state.selecionado;
    final linhas = state.tabela.linhas.length;

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
            padding: EdgeInsets.fromLTRB(
              onVoltar == null ? Spacing.md.width : Spacing.xs.width,
              Spacing.sm.height,
              Spacing.md.width,
              Spacing.sm.height,
            ),
            child: Row(
              children: [
                if (onVoltar != null)
                  IconButton(
                    tooltip: 'Voltar para a lista',
                    onPressed: onVoltar,
                    icon: const Icon(Icons.arrow_back),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        edicao ? 'CÓDIGO ${material?.codigoFormatado}' : 'NOVO MATERIAL',
                        style: SimTypography.overlineSemiBold.copyWith(
                          color: edicao ? SimTokens.colorNeutral500 : SimTokens.colorPrimary500,
                        ),
                      ),
                      Text(
                        edicao ? material!.nome : 'Cadastrar material',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: SimTypography.titleLgMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (edicao)
            Padding(
              padding: EdgeInsets.fromLTRB(Spacing.md.width, 0, Spacing.md.width, Spacing.sm.height),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SimSegmentedControl<MaterialAba>(
                  opcoes: {
                    MaterialAba.dados: 'Dados',
                    MaterialAba.tabela: state.carregandoTabela && linhas == 0
                        ? 'Tabela de bitolas'
                        : 'Tabela de bitolas ($linhas)',
                  },
                  selecionado: state.aba,
                  onChanged: viewModel.alterarAba,
                ),
              ),
            ),
          const Divider(),
          Expanded(
            child: edicao && state.aba == MaterialAba.tabela
                ? TabelaBitolasPainel(
                    state: state,
                    onBuscar: viewModel.buscarNaTabela,
                    onEditarColunas: onEditarColunas,
                    onAdicionarLinha: onAdicionarLinha,
                    onEditarLinha: onEditarLinha,
                    onExcluirLinha: onExcluirLinha,
                    onMoverLinha: viewModel.moverLinha,
                    onTentarNovamente: viewModel.carregarTabela,
                  )
                : _Dados(formKey: formKey, viewModel: viewModel, state: state),
          ),
          if (!edicao || state.aba == MaterialAba.dados) ...[
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.md.width, vertical: Spacing.sm.height),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: Spacing.xs.width,
                  runSpacing: Spacing.xs.height,
                  children: [
                    if (edicao)
                      SimButton(
                        label: 'Excluir',
                        icon: Icons.delete_outline,
                        style: SimButtonStyle.perigo,
                        height: 44,
                        onPressed: onExcluir,
                      )
                    else
                      const SizedBox.shrink(),
                    Wrap(
                      spacing: Spacing.xs.width,
                      runSpacing: Spacing.xs.height,
                      children: [
                        SimButton(
                          label: 'Cancelar',
                          style: SimButtonStyle.secundario,
                          height: 44,
                          onPressed: onCancelar,
                        ),
                        SimButton(
                          label: state.salvando ? 'Salvando…' : 'Salvar',
                          icon: Icons.check,
                          height: 44,
                          isActive: !state.salvando,
                          onPressed: onSalvar,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Dados extends StatelessWidget {
  const _Dados({required this.formKey, required this.viewModel, required this.state});

  final GlobalKey<FormState> formKey;
  final MateriaisViewModel viewModel;
  final MateriaisState state;

  @override
  Widget build(BuildContext context) {
    final colunas = state.tabela.colunas;
    final grupos = state.grupos;
    final grupo = state.grupo;

    return SingleChildScrollView(
      padding: EdgeInsets.all(Spacing.md.width),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimSecaoFormulario(
              titulo: 'Identificação',
              icone: Icons.category_outlined,
              linhas: [
                [
                  (
                    SimDropdownField<GrupoMaterialModel>(
                      label: 'Grupo',
                      obrigatorio: true,
                      hint: 'Selecione',
                      valor: grupo,
                      itens: {
                        for (final g in grupos) g: g.nome,
                        // Grupo que deixou de existir continua visível no material já cadastrado.
                        if (grupo != null && !grupos.contains(grupo)) grupo: grupo.nome,
                      },
                      validator: (g) => g == null ? 'Escolha o grupo' : null,
                      onChanged: viewModel.alterarGrupo,
                    ),
                    2,
                  ),
                  (
                    SimTextField(
                      label: 'Subgrupo',
                      hint: 'Ex.: Redonda, SCH. 40',
                      controller: viewModel.descricaoController,
                      maxLength: 60,
                    ),
                    3,
                  ),
                ],
              ],
            ),
            const SimSeparadorFormulario(),
            const SimTituloSecao(titulo: 'No orçamento', icone: Icons.request_quote_outlined),
            Spacing.sm.vertical,
            const SimFieldLabel('Medidas pedidas'),
            Wrap(
              spacing: Spacing.xs.width,
              runSpacing: Spacing.xs.height,
              children: [
                for (final medida in MedidaOrcamento.values)
                  FilterChip(
                    label: Text(medida.descricao),
                    selected: state.medidas.contains(medida),
                    onSelected: (pedir) => viewModel.alterarMedida(medida, pedir: pedir),
                  ),
              ],
            ),
            Spacing.sm.vertical,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: SimDropdownField<int?>(
                label: 'Coluna da bitola',
                valor: state.colunaBitola,
                itens: {
                  null: colunas.isEmpty ? 'Sem tabela de bitolas' : 'Nenhuma',
                  for (final (i, coluna) in colunas.indexed) i: coluna,
                  // A coluna do material chega antes da tabela; até ela carregar, mostra só a posição.
                  if (state.colunaBitola case final coluna? when coluna >= colunas.length)
                    coluna: 'Coluna ${coluna + 1}',
                },
                onChanged: viewModel.alterarColunaBitola,
              ),
            ),
            Text(
              'Ao escolher uma bitola no orçamento, o valor desta coluna vai para "Diâmetro/bitola".',
              style: SimTypography.bodyXsRegular,
            ),
            Spacing.sm.vertical,
            _Opcao(
              titulo: 'Orçamento com valor zero',
              descricao: 'O material entra no orçamento sem preço.',
              valor: state.valorZero,
              onChanged: viewModel.alterarValorZero,
            ),
            _Opcao(
              titulo: 'Descrição em branco',
              valor: state.descricaoEmBranco,
              onChanged: viewModel.alterarDescricaoEmBranco,
            ),
            _Opcao(
              titulo: 'Exibir no subitem',
              valor: state.exibirNoSubitem,
              onChanged: viewModel.alterarExibirNoSubitem,
            ),
          ],
        ),
      ),
    );
  }
}

class _Opcao extends StatelessWidget {
  const _Opcao({required this.titulo, required this.valor, required this.onChanged, this.descricao});

  final String titulo;
  final String? descricao;
  final bool valor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Switch(value: valor, onChanged: onChanged),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: SimTypography.bodySmSemiBold),
                if (descricao != null) Text(descricao!, style: SimTypography.bodyXsRegular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
