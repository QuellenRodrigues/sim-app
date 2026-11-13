import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../views/fornecedores/fornecedores_state.dart';
import '../views/fornecedores/fornecedores_viewmodel.dart';
import 'fornecedor_precos.dart';

/// Formulário do fornecedor, com os grupos do sistema antigo. Não há excluir:
/// no SIM o fornecedor sai de uso sendo suspenso ou marcado como inativo.
class FornecedorFormulario extends StatelessWidget {
  const FornecedorFormulario({
    required this.formKey,
    required this.viewModel,
    required this.state,
    required this.onSalvar,
    required this.onCancelar,
    required this.onSuspender,
    required this.onAdicionarMateriais,
    required this.onRemoverMaterial,
    required this.onAdicionarPreco,
    required this.onEditarPreco,
    required this.onExcluirPreco,
    super.key,
    this.onVoltar,
  });

  final GlobalKey<FormState> formKey;
  final FornecedoresViewModel viewModel;
  final FornecedoresState state;
  final VoidCallback onSalvar;
  final VoidCallback onCancelar;
  final VoidCallback onSuspender;
  final VoidCallback onAdicionarMateriais;
  final ValueChanged<MaterialFornecidoModel> onRemoverMaterial;
  final VoidCallback onAdicionarPreco;
  final ValueChanged<PrecoMaterialModel> onEditarPreco;
  final ValueChanged<PrecoMaterialModel> onExcluirPreco;

  /// Exibe a seta de voltar (layout de celular).
  final VoidCallback? onVoltar;

  @override
  Widget build(BuildContext context) {
    final edicao = state.modo == FornecedoresModo.edicao;
    final fornecedor = state.selecionado;
    final suspensoEm = fornecedor?.suspensoEm;

    return Container(
      decoration: BoxDecoration(
        color: SimTokens.colorWhite,
        borderRadius: BorderRadius.circular(SimTokens.roundedLg),
        border: Border.all(color: SimTokens.colorBorder),
      ),
      child: Column(
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
                        edicao ? 'CÓDIGO ${fornecedor?.codigoFormatado}' : 'NOVO FORNECEDOR',
                        style: SimTypography.overlineSemiBold.copyWith(
                          color: edicao ? SimTokens.colorNeutral500 : SimTokens.colorPrimary500,
                        ),
                      ),
                      Text(
                        edicao ? fornecedor!.razaoSocial : 'Cadastrar fornecedor',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: SimTypography.titleLgMedium,
                      ),
                    ],
                  ),
                ),
                if (suspensoEm != null) ...[
                  Spacing.xs.horizontal,
                  SimStatusChip(
                    label: 'Suspenso desde ${DateFormat('dd/MM/yyyy', 'pt_BR').format(suspensoEm)}',
                    type: SimStatusType.alerta,
                  ),
                ],
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Spacing.md.width),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SimSecaoFormulario(
                      titulo: 'Dados da empresa',
                      icone: Icons.business_outlined,
                      linhas: [
                        [
                          (
                            SimTextField(
                              label: 'Razão social',
                              obrigatorio: true,
                              controller: viewModel.razaoSocialController,
                              maxLength: 60,
                              validator: SimValidatorless.obrigatorio('Informe a razão social'),
                            ),
                            1,
                          ),
                        ],
                        [
                          (
                            SimTextField(
                              label: 'Nome fantasia',
                              controller: viewModel.nomeFantasiaController,
                              maxLength: 50,
                            ),
                            3,
                          ),
                          (
                            SimTextField(
                              label: 'CNPJ',
                              hint: '00.000.000/0000-00',
                              controller: viewModel.cnpjController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [MaskInputFormatter.cnpj()],
                              validator: SimValidatorless.cnpj(),
                            ),
                            2,
                          ),
                        ],
                        [
                          (
                            SimTextField(
                              label: 'Inscrição estadual',
                              controller: viewModel.inscricaoEstadualController,
                              maxLength: 20,
                            ),
                            1,
                          ),
                          (
                            SimTextField(
                              label: 'Inscrição municipal',
                              controller: viewModel.inscricaoMunicipalController,
                              maxLength: 20,
                            ),
                            1,
                          ),
                        ],
                        [
                          (
                            _Inativo(valor: state.inativo, onChanged: viewModel.alterarInativo),
                            1,
                          ),
                        ],
                      ],
                    ),
                    const SimSeparadorFormulario(),
                    SimSecaoFormulario(
                      titulo: 'Endereço',
                      icone: Icons.location_on_outlined,
                      linhas: [
                        [
                          (
                            SimTextField(
                              label: 'Endereço',
                              hint: 'Rua, número e complemento',
                              controller: viewModel.enderecoController,
                              maxLength: 60,
                            ),
                            3,
                          ),
                          (
                            SimTextField(
                              label: 'Bairro',
                              controller: viewModel.bairroController,
                              maxLength: 50,
                            ),
                            2,
                          ),
                        ],
                        [
                          (
                            SimTextField(
                              label: 'Cidade',
                              controller: viewModel.cidadeController,
                              maxLength: 50,
                            ),
                            3,
                          ),
                          (
                            SimDropdownField<UnidadeFederativa>(
                              label: 'Estado',
                              hint: 'Selecione',
                              valor: state.estado,
                              itens: {
                                for (final uf in UnidadeFederativa.values) uf: '${uf.sigla} — ${uf.nome}',
                              },
                              onChanged: viewModel.alterarEstado,
                            ),
                            2,
                          ),
                          (
                            SimTextField(
                              label: 'CEP',
                              hint: '00000-000',
                              controller: viewModel.cepController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [MaskInputFormatter.cep()],
                              validator: SimValidatorless.cep(),
                            ),
                            2,
                          ),
                        ],
                      ],
                    ),
                    const SimSeparadorFormulario(),
                    SimSecaoFormulario(
                      titulo: 'Contato',
                      icone: Icons.contact_phone_outlined,
                      linhas: [
                        [
                          (
                            SimTextField(
                              label: 'Contato',
                              hint: 'Nome da pessoa de contato',
                              controller: viewModel.contatoController,
                              maxLength: 50,
                            ),
                            1,
                          ),
                          (SimEmailField(label: 'E-mail', controller: viewModel.emailController), 1),
                        ],
                        [
                          (SimEmailField(label: 'E-mail 2', controller: viewModel.email2Controller), 1),
                          (SimEmailField(label: 'E-mail 3', controller: viewModel.email3Controller), 1),
                        ],
                        [
                          (
                            SimTelefoneField(label: 'Telefone 1', controller: viewModel.telefone1Controller),
                            1,
                          ),
                          (
                            SimTelefoneField(label: 'Telefone 2', controller: viewModel.telefone2Controller),
                            1,
                          ),
                          (
                            SimTelefoneField(label: 'Telefone 3', controller: viewModel.telefone3Controller),
                            1,
                          ),
                          (SimTelefoneField(label: 'Fax', controller: viewModel.faxController), 1),
                        ],
                      ],
                    ),
                    const SimSeparadorFormulario(),
                    _Materiais(
                      state: state,
                      onAdicionar: onAdicionarMateriais,
                      onRemover: onRemoverMaterial,
                      onTentarNovamente: viewModel.carregarMateriais,
                    ),
                    if (edicao) ...[
                      const SimSeparadorFormulario(),
                      FornecedorPrecos(
                        precos: state.precos,
                        podeAdicionar: state.materiais.isNotEmpty,
                        onAdicionar: onAdicionarPreco,
                        onEditar: onEditarPreco,
                        onExcluir: onExcluirPreco,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
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
                      label: fornecedor!.suspenso ? 'Retirar suspensão' : 'Suspender',
                      icon: fornecedor.suspenso ? Icons.play_circle_outline : Icons.pause_circle_outline,
                      style: SimButtonStyle.secundario,
                      height: 44,
                      onPressed: onSuspender,
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
      ),
    );
  }
}

class _Inativo extends StatelessWidget {
  const _Inativo({required this.valor, required this.onChanged});

  final bool valor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(value: valor, onChanged: onChanged),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Inativo', style: SimTypography.bodySmSemiBold),
              Text(
                'Continua no cadastro, mas não aparece nas compras.',
                style: SimTypography.bodyXsRegular,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Materiais fornecidos. Como no sistema antigo, são gravados na hora, sem passar pelo "Salvar".
class _Materiais extends StatelessWidget {
  const _Materiais({
    required this.state,
    required this.onAdicionar,
    required this.onRemover,
    required this.onTentarNovamente,
  });

  final FornecedoresState state;
  final VoidCallback onAdicionar;
  final ValueChanged<MaterialFornecidoModel> onRemover;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    final salvo = state.modo == FornecedoresModo.edicao;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SimTituloSecao(titulo: 'Materiais fornecidos', icone: Icons.inventory_2_outlined),
        Spacing.sm.vertical,
        _conteudo(salvo),
        if (salvo) ...[
          Spacing.sm.vertical,
          Align(
            alignment: Alignment.centerLeft,
            child: SimButton(
              label: 'Adicionar materiais',
              icon: Icons.add,
              style: SimButtonStyle.secundario,
              onPressed: onAdicionar,
            ),
          ),
        ],
      ],
    );
  }

  Widget _conteudo(bool salvo) {
    if (!salvo) {
      return _Aviso('Salve o fornecedor para informar os materiais que ele fornece.');
    }
    if (state.erroMateriais != null) {
      return SimMensagem(
        icone: Icons.cloud_off_outlined,
        texto: state.erroMateriais!,
        acao: SimButton(
          label: 'Tentar novamente',
          style: SimButtonStyle.secundario,
          onPressed: onTentarNovamente,
        ),
      );
    }
    if (state.materiais.isEmpty) {
      return state.carregandoMateriais
          ? const Center(child: SimCircularLoading())
          : _Aviso('Nenhum material informado.');
    }

    return Wrap(
      spacing: Spacing.xs.width,
      runSpacing: Spacing.xs.height,
      children: [
        for (final material in state.materiais)
          InputChip(
            label: Text(material.nome, style: SimTypography.bodySmRegular),
            backgroundColor: SimTokens.colorNeutral50,
            side: const BorderSide(color: SimTokens.colorBorder),
            deleteIcon: const Icon(Icons.close, size: 16),
            deleteButtonTooltipMessage: 'Remover',
            onDeleted: () => onRemover(material),
          ),
      ],
    );
  }
}

class _Aviso extends StatelessWidget {
  const _Aviso(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(texto, style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500));
  }
}
