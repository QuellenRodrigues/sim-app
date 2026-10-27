import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../views/clientes/clientes_state.dart';
import '../views/clientes/clientes_viewmodel.dart';

/// Formulário do cliente, com os grupos do sistema antigo:
/// dados da empresa, endereço, contato e outros contatos.
class ClienteFormulario extends StatelessWidget {
  const ClienteFormulario({
    required this.formKey,
    required this.viewModel,
    required this.state,
    required this.onSalvar,
    required this.onCancelar,
    required this.onExcluir,
    required this.onTaxas,
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
  final VoidCallback onTaxas;
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
                    _Secao(
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
                      ],
                    ),
                    const _Separador(),
                    _Secao(
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
                    const _Separador(),
                    _Secao(
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
                              maxLength: 255,
                              validator: SimValidatorless.email(),
                            ),
                            1,
                          ),
                        ],
                        [
                          (_Telefone(label: 'Telefone 1', controller: viewModel.telefone1Controller), 1),
                          (_Telefone(label: 'Telefone 2', controller: viewModel.telefone2Controller), 1),
                          (_Telefone(label: 'Telefone 3', controller: viewModel.telefone3Controller), 1),
                        ],
                      ],
                    ),
                    const _Separador(),
                    _Secao(
                      titulo: 'Outros contatos',
                      icone: Icons.phone_in_talk_outlined,
                      linhas: [
                        [
                          (_Telefone(label: 'Fax', controller: viewModel.faxController), 1),
                          (_Telefone(label: 'Nextel', controller: viewModel.nextelController), 1),
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
                      if (edicao) ...[
                        SimButton(
                          label: 'Excluir',
                          icon: Icons.delete_outline,
                          style: SimButtonStyle.perigo,
                          height: 44,
                          onPressed: onExcluir,
                        ),
                        SimButton(
                          label: 'Taxas e impostos',
                          icon: Icons.percent,
                          style: SimButtonStyle.secundario,
                          height: 44,
                          onPressed: onTaxas,
                        ),
                      ],
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
}

class _Telefone extends StatelessWidget {
  const _Telefone({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SimTextField(
      label: label,
      hint: '(00) 0000-0000',
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [MaskInputFormatter.telefone()],
      validator: SimValidatorless.telefone(),
    );
  }
}

class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.md.height),
      child: const Divider(color: SimTokens.colorNeutral100),
    );
  }
}

/// Grupo de campos com título; cada linha vira coluna em telas estreitas.
class _Secao extends StatelessWidget {
  const _Secao({required this.titulo, required this.icone, required this.linhas});

  final String titulo;
  final IconData icone;

  /// Linhas de campos; cada campo traz o seu `flex` na linha.
  final List<List<(Widget, int)>> linhas;

  @override
  Widget build(BuildContext context) {
    final espaco = Spacing.sm.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: SimTokens.colorPrimary50,
                borderRadius: BorderRadius.circular(SimTokens.roundedSm),
              ),
              child: Icon(icone, size: 18, color: SimTokens.colorPrimary500),
            ),
            const SizedBox(width: 10),
            Text(titulo, style: SimTypography.titleSmSemiBold),
          ],
        ),
        Spacing.sm.vertical,
        LayoutBuilder(
          builder: (context, constraints) {
            final empilhar = constraints.maxWidth < 560;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, linha) in linhas.indexed) ...[
                  if (i > 0) SizedBox(height: espaco),
                  if (empilhar)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final (j, (campo, _)) in linha.indexed) ...[
                          if (j > 0) SizedBox(height: espaco),
                          campo,
                        ],
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (j, (campo, flex)) in linha.indexed) ...[
                          if (j > 0) SizedBox(width: espaco),
                          Expanded(flex: flex, child: campo),
                        ],
                      ],
                    ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
