import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/domain.dart';
import '../views/clientes/clientes_state.dart';
import '../views/clientes/clientes_viewmodel.dart';

/// Formulário do cliente, com os grupos do sistema antigo:
/// dados da empresa, endereço, contato, outros contatos e impostos.
class ClienteFormulario extends StatelessWidget {
  const ClienteFormulario({
    required this.formKey,
    required this.viewModel,
    required this.state,
    required this.onSalvar,
    required this.onCancelar,
    required this.onExcluir,
    required this.onEstado,
    super.key,
    this.onVoltar,
  });

  final GlobalKey<FormState> formKey;
  final ClientesViewModel viewModel;
  final ClientesState state;
  final VoidCallback onSalvar;
  final VoidCallback onCancelar;
  final VoidCallback onExcluir;
  final ValueChanged<UnidadeFederativa?> onEstado;

  /// Exibe a seta de voltar (layout de celular).
  final VoidCallback? onVoltar;

  @override
  Widget build(BuildContext context) {
    final edicao = state.modo == ClientesModo.edicao;
    final cliente = state.selecionado;

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
                        edicao ? 'CÓDIGO ${cliente?.codigoFormatado}' : 'NOVO CLIENTE',
                        style: SimTypography.overlineSemiBold.copyWith(
                          color: edicao ? SimTokens.colorNeutral500 : SimTokens.colorPrimary500,
                        ),
                      ),
                      Text(
                        edicao ? cliente!.razaoSocial : 'Cadastrar cliente',
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
                              maxLength: 120,
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
                              maxLength: 80,
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
                              maxLength: 150,
                            ),
                            3,
                          ),
                          (
                            SimTextField(
                              label: 'Bairro',
                              controller: viewModel.bairroController,
                              maxLength: 80,
                            ),
                            2,
                          ),
                        ],
                        [
                          (
                            SimTextField(
                              label: 'Cidade',
                              controller: viewModel.cidadeController,
                              maxLength: 80,
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
                              onChanged: onEstado,
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
                              maxLength: 80,
                            ),
                            1,
                          ),
                          (
                            SimTextField(
                              label: 'E-mail',
                              hint: 'nome@empresa.com.br',
                              controller: viewModel.emailController,
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 50,
                              validator: SimValidatorless.email(),
                            ),
                            1,
                          ),
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
                        ],
                      ],
                    ),
                    const SimSeparadorFormulario(),
                    SimSecaoFormulario(
                      titulo: 'Outros contatos',
                      icone: Icons.phone_in_talk_outlined,
                      linhas: [
                        [
                          (SimTelefoneField(label: 'Fax', controller: viewModel.faxController), 1),
                          (SimTelefoneField(label: 'Nextel', controller: viewModel.nextelController), 1),
                          (
                            SimTextField(
                              label: 'Nextel ID',
                              controller: viewModel.nextelIdController,
                              maxLength: 20,
                            ),
                            1,
                          ),
                        ],
                      ],
                    ),
                    const SimSeparadorFormulario(),
                    SimSecaoFormulario(
                      titulo: 'Impostos',
                      descricao: 'Padrão usado nos orçamentos deste cliente.',
                      icone: Icons.receipt_long_outlined,
                      linhas: [
                        [
                          (
                            _Tributacao(
                              label: 'ICMS',
                              valor: state.icms,
                              onChanged: viewModel.alterarIcms,
                            ),
                            1,
                          ),
                          (
                            SimDropdownField<DestinacaoIcms>(
                              label: 'Destinação',
                              valor: state.destinacaoIcms,
                              itens: {for (final d in DestinacaoIcms.values) d: d.descricao},
                              onChanged: (destinacao) => viewModel.alterarDestinacaoIcms(destinacao!),
                            ),
                            1,
                          ),
                          (
                            _Informacao(
                              label: 'Alíquota do ICMS',
                              valor: _aliquotaIcms(state.estado),
                            ),
                            1,
                          ),
                        ],
                        [
                          (
                            _Tributacao(
                              label: 'ISS',
                              valor: state.iss,
                              onChanged: viewModel.alterarIss,
                            ),
                            1,
                          ),
                          (
                            SimTextField(
                              label: 'Alíquota do ISS (%)',
                              hint: '0',
                              controller: viewModel.aliquotaIssController,
                              enabled: state.iss != TributacaoImposto.naoIncidente,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,]'))],
                              maxLength: 6,
                              validator: _validarPorcentagem,
                            ),
                            1,
                          ),
                          (
                            _Tributacao(
                              label: 'IPI',
                              valor: state.ipi,
                              onChanged: viewModel.alterarIpi,
                            ),
                            1,
                          ),
                        ],
                      ],
                    ),
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
                  Wrap(
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
                        ),
                    ],
                  ),
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

  /// "19% (RJ)", ou uma orientação quando não há estado ou alíquota.
  static String _aliquotaIcms(UnidadeFederativa? estado) {
    if (estado == null) return 'Escolha o estado';
    final aliquota = AliquotaIcms.de(estado);
    if (aliquota == null) return 'Sem alíquota para ${estado.sigla}';
    return '${NumberFormatter.percentual(aliquota)} (${estado.sigla})';
  }

  static String? _validarPorcentagem(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return null;
    final numero = NumberFormatter.lerDecimal(texto);
    if (numero == null || numero > 100) return 'Informe uma porcentagem de 0 a 100';
    return null;
  }
}

class _Tributacao extends StatelessWidget {
  const _Tributacao({required this.label, required this.valor, required this.onChanged});

  final String label;
  final TributacaoImposto valor;
  final ValueChanged<TributacaoImposto> onChanged;

  @override
  Widget build(BuildContext context) {
    return SimDropdownField<TributacaoImposto>(
      label: label,
      valor: valor,
      itens: {for (final t in TributacaoImposto.values) t: t.descricao},
      onChanged: (tributacao) => onChanged(tributacao!),
    );
  }
}

/// Valor calculado pelo sistema, exibido no lugar de um campo.
class _Informacao extends StatelessWidget {
  const _Informacao({required this.label, required this.valor});

  final String label;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SimFieldLabel(label),
        Container(
          height: 44,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: SimTokens.colorNeutral50,
            borderRadius: BorderRadius.circular(SimTokens.roundedSm),
            border: Border.all(color: SimTokens.colorBorder),
          ),
          child: Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral700),
          ),
        ),
      ],
    );
  }
}
