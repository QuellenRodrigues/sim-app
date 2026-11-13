import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/domain.dart';

/// Diálogo para informar o preço de um item em um fornecedor.
class PrecoMaterialDialog extends StatefulWidget {
  const PrecoMaterialDialog({
    required this.codigoFornecedor,
    required this.materiais,
    required this.onSalvar,
    super.key,
    this.preco,
  });

  final int codigoFornecedor;

  /// Materiais que o fornecedor fornece.
  final List<MaterialFornecidoModel> materiais;

  /// `null` para incluir.
  final PrecoMaterialModel? preco;

  /// Salva o preço; retorna `true` se deu certo, e então o diálogo fecha.
  final Future<bool> Function(PrecoMaterialModel preco) onSalvar;

  static Future<void> mostrar(
    BuildContext context, {
    required int codigoFornecedor,
    required List<MaterialFornecidoModel> materiais,
    required Future<bool> Function(PrecoMaterialModel preco) onSalvar,
    PrecoMaterialModel? preco,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => PrecoMaterialDialog(
        codigoFornecedor: codigoFornecedor,
        materiais: materiais,
        preco: preco,
        onSalvar: onSalvar,
      ),
    );
  }

  @override
  State<PrecoMaterialDialog> createState() => _PrecoMaterialDialogState();
}

class _PrecoMaterialDialogState extends State<PrecoMaterialDialog> {
  static const _unidades = ['UN', 'KG', 'M', 'M²', 'L', 'CX'];

  final _formKey = GlobalKey<FormState>();
  late final _especificacaoController = TextEditingController(text: widget.preco?.especificacao);
  late final _precoController = TextEditingController(text: _decimal(widget.preco?.preco));
  late final _ipiController = TextEditingController(text: _decimal(widget.preco?.ipiPercentual));
  late final _condicaoController = TextEditingController(text: widget.preco?.condicaoPagamento);
  late final _prazoController = TextEditingController(
    text: (widget.preco?.prazoDias ?? 0) > 0 ? widget.preco!.prazoDias.toString() : '',
  );

  late MaterialFornecidoModel? _material = widget.preco?.material;
  late String _unidade = widget.preco?.unidade ?? _unidades.first;
  late FreteCotacao _frete = widget.preco?.frete ?? FreteCotacao.fob;
  bool _salvando = false;

  static String _decimal(double? valor) => valor == null || valor == 0 ? '' : NumberFormatter.decimal(valor);

  static String? _validarPreco(String? valor) {
    final preco = NumberFormatter.lerDecimal(valor ?? '');
    return preco == null || preco <= 0 ? 'Informe o preço' : null;
  }

  static String? _validarIpi(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return null;
    final ipi = NumberFormatter.lerDecimal(texto);
    return ipi == null || ipi > 100 ? 'De 0 a 100' : null;
  }

  Future<void> _salvar() async {
    if (_salvando || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _salvando = true);

    final salvou = await widget.onSalvar(
      PrecoMaterialModel(
        codigo: widget.preco?.codigo,
        codigoFornecedor: widget.codigoFornecedor,
        material: _material!,
        especificacao: _especificacaoController.text.trim(),
        unidade: _unidade,
        preco: NumberFormatter.lerDecimal(_precoController.text)!,
        ipiPercentual: NumberFormatter.lerDecimal(_ipiController.text) ?? 0,
        frete: _frete,
        condicaoPagamento: _condicaoController.text.trim(),
        prazoDias: int.tryParse(_prazoController.text) ?? 0,
      ),
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
    _especificacaoController.dispose();
    _precoController.dispose();
    _ipiController.dispose();
    _condicaoController.dispose();
    _prazoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9,]'))];
    const teclado = TextInputType.numberWithOptions(decimal: true);

    return AlertDialog(
      backgroundColor: SimTokens.colorWhite,
      surfaceTintColor: SimTokens.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SimTokens.roundedLg)),
      title: Text(
        widget.preco == null ? 'Adicionar preço' : 'Editar preço',
        style: SimTypography.titleLgMedium,
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SimSecaoFormularioCampos(
              larguraMinima: 460,
              linhas: [
                [
                  (
                    SimDropdownField<MaterialFornecidoModel>(
                      label: 'Material',
                      obrigatorio: true,
                      hint: 'Selecione',
                      valor: _material,
                      itens: {for (final m in widget.materiais) m: m.nome},
                      validator: (material) => material == null ? 'Escolha o material' : null,
                      onChanged: (material) => setState(() => _material = material),
                    ),
                    1,
                  ),
                ],
                [
                  (
                    SimTextField(
                      label: 'Especificação',
                      hint: 'Ex.: M10 x 50 zincado',
                      controller: _especificacaoController,
                      maxLength: 80,
                    ),
                    1,
                  ),
                ],
                [
                  (
                    SimTextField(
                      label: 'Preço (R\$)',
                      obrigatorio: true,
                      hint: '0,00',
                      controller: _precoController,
                      keyboardType: teclado,
                      inputFormatters: decimal,
                      maxLength: 12,
                      validator: _validarPreco,
                    ),
                    2,
                  ),
                  (
                    SimDropdownField<String>(
                      label: 'Unidade',
                      valor: _unidade,
                      itens: {
                        for (final u in {..._unidades, _unidade}) u: u,
                      },
                      onChanged: (unidade) => setState(() => _unidade = unidade!),
                    ),
                    1,
                  ),
                  (
                    SimTextField(
                      label: 'IPI (%)',
                      hint: '0',
                      controller: _ipiController,
                      keyboardType: teclado,
                      inputFormatters: decimal,
                      maxLength: 6,
                      validator: _validarIpi,
                    ),
                    1,
                  ),
                ],
                [
                  (
                    SimDropdownField<FreteCotacao>(
                      label: 'Frete',
                      valor: _frete,
                      itens: {for (final f in FreteCotacao.values) f: f.descricao},
                      onChanged: (frete) => setState(() => _frete = frete!),
                    ),
                    1,
                  ),
                  (
                    SimTextField(
                      label: 'Pagamento (dias)',
                      hint: '30/45/60',
                      controller: _condicaoController,
                      maxLength: 30,
                    ),
                    1,
                  ),
                  (
                    SimTextField(
                      label: 'Entrega (dias)',
                      hint: '0',
                      controller: _prazoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 4,
                    ),
                    1,
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
