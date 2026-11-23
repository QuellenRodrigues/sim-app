import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Diálogo para definir o nome, a unidade e as colunas da tabela de bitolas (até 20).
class ColunasTabelaDialog extends StatefulWidget {
  const ColunasTabelaDialog({required this.tabela, required this.onSalvar, super.key});

  final TabelaBitolasModel tabela;

  /// Salva a estrutura; retorna `true` se deu certo, e então o diálogo fecha.
  final Future<bool> Function({
    required String nome,
    required UnidadeTabela unidade,
    required List<ColunaEdicao> colunas,
  })
  onSalvar;

  static Future<void> mostrar(
    BuildContext context, {
    required TabelaBitolasModel tabela,
    required Future<bool> Function({
      required String nome,
      required UnidadeTabela unidade,
      required List<ColunaEdicao> colunas,
    })
    onSalvar,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => ColunasTabelaDialog(tabela: tabela, onSalvar: onSalvar),
    );
  }

  @override
  State<ColunasTabelaDialog> createState() => _ColunasTabelaDialogState();
}

class _Coluna {
  _Coluna(String nome, this.origem) : controller = TextEditingController(text: nome);

  final TextEditingController controller;

  /// Posição antes de editar; `null` para coluna nova.
  final int? origem;
}

class _ColunasTabelaDialogState extends State<ColunasTabelaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nomeController = TextEditingController(text: widget.tabela.nome);
  late UnidadeTabela _unidade = widget.tabela.unidade;
  late final List<_Coluna> _colunas = [
    for (final (i, nome) in widget.tabela.colunas.indexed) _Coluna(nome, i),
    if (widget.tabela.colunas.isEmpty) _Coluna('', null),
  ];
  final List<_Coluna> _removidas = [];
  bool _salvando = false;

  bool get _removeuComDados => widget.tabela.linhas.isNotEmpty && _removidas.any((c) => c.origem != null);

  void _adicionar() => setState(() => _colunas.add(_Coluna('', null)));

  void _remover(_Coluna coluna) {
    setState(() {
      _colunas.remove(coluna);
      _removidas.add(coluna);
    });
  }

  Future<void> _salvar() async {
    if (_salvando || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _salvando = true);
    final salvou = await widget.onSalvar(
      nome: _nomeController.text.trim(),
      unidade: _unidade,
      colunas: [for (final c in _colunas) ColunaEdicao(nome: c.controller.text.trim(), origem: c.origem)],
    );
    if (!mounted) return;
    if (salvou) {
      Navigator.of(context).pop();
    } else {
      setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    for (final coluna in [..._colunas, ..._removidas]) {
      coluna.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cheio = _colunas.length >= TabelaBitolasModel.maximoColunas;

    return AlertDialog(
      backgroundColor: SimTokens.colorWhite,
      surfaceTintColor: SimTokens.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SimTokens.roundedLg)),
      title: Text('Colunas da tabela', style: SimTypography.titleLgMedium),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SimSecaoFormularioCampos(
                  larguraMinima: 380,
                  linhas: [
                    [
                      (
                        SimTextField(label: 'Nome da tabela', controller: _nomeController, maxLength: 60),
                        3,
                      ),
                      (
                        SimDropdownField<UnidadeTabela>(
                          label: 'Unidade',
                          valor: _unidade,
                          itens: {for (final u in UnidadeTabela.values) u: u.descricao},
                          onChanged: (unidade) => setState(() => _unidade = unidade!),
                        ),
                        2,
                      ),
                    ],
                  ],
                ),
                Spacing.sm.vertical,
                for (final (i, coluna) in _colunas.indexed)
                  Padding(
                    padding: EdgeInsets.only(bottom: Spacing.xs.height),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SimTextField(
                            label: 'Coluna ${i + 1}',
                            obrigatorio: true,
                            controller: coluna.controller,
                            maxLength: 30,
                            validator: SimValidatorless.obrigatorio('Dê um nome à coluna'),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remover coluna',
                          onPressed: _colunas.length == 1 ? null : () => _remover(coluna),
                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                        ),
                      ],
                    ),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SimButton(
                    label: cheio
                        ? 'Limite de ${TabelaBitolasModel.maximoColunas} colunas'
                        : 'Adicionar coluna',
                    icon: Icons.add,
                    style: SimButtonStyle.texto,
                    isActive: !cheio,
                    onPressed: _adicionar,
                  ),
                ),
                if (_removeuComDados) ...[
                  Spacing.xs.vertical,
                  Text(
                    'Os valores das colunas removidas serão apagados de todas as linhas.',
                    style: SimTypography.bodyXsRegular.copyWith(color: SimTokens.colorError700),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      actions: [
        SimButton(
          label: 'Cancelar',
          style: SimButtonStyle.secundario,
          onPressed: () => Navigator.of(context).pop(),
        ),
        SimButton(
          label: _salvando ? 'Salvando…' : 'Salvar',
          icon: Icons.check,
          isActive: !_salvando,
          onPressed: _salvar,
        ),
      ],
    );
  }
}
