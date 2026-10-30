import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Diálogo para incluir ou editar a descrição de um item de tabela auxiliar.
class ItemTabelaDialog extends StatefulWidget {
  const ItemTabelaDialog({required this.tabela, required this.onSalvar, super.key, this.item});

  final TabelaAuxiliar tabela;

  /// `null` para incluir.
  final ItemTabelaModel? item;

  /// Salva a descrição; retorna `true` se deu certo, e então o diálogo fecha.
  final Future<bool> Function(String descricao) onSalvar;

  static Future<void> mostrar(
    BuildContext context, {
    required TabelaAuxiliar tabela,
    required Future<bool> Function(String descricao) onSalvar,
    ItemTabelaModel? item,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => ItemTabelaDialog(tabela: tabela, item: item, onSalvar: onSalvar),
    );
  }

  @override
  State<ItemTabelaDialog> createState() => _ItemTabelaDialogState();
}

class _ItemTabelaDialogState extends State<ItemTabelaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _descricaoController = TextEditingController(text: widget.item?.descricao);
  bool _salvando = false;

  Future<void> _salvar() async {
    if (_salvando || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _salvando = true);
    final salvou = await widget.onSalvar(_descricaoController.text.trim());
    if (!mounted) return;
    if (salvou) {
      Navigator.of(context).pop();
    } else {
      setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return AlertDialog(
      backgroundColor: SimTokens.colorWhite,
      surfaceTintColor: SimTokens.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SimTokens.roundedLg)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item == null ? widget.tabela.titulo.toUpperCase() : 'CÓDIGO ${item.codigoFormatado}',
            style: SimTypography.overlineSemiBold.copyWith(color: SimTokens.colorPrimary500),
          ),
          Text(item == null ? 'Adicionar item' : 'Editar item', style: SimTypography.titleLgMedium),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SimTextField(
            label: 'Descrição',
            obrigatorio: true,
            controller: _descricaoController,
            maxLength: widget.tabela.tamanhoMaximo,
            textInputAction: TextInputAction.done,
            autofocus: true,
            validator: SimValidatorless.obrigatorio('Informe a descrição'),
            onSubmitted: (_) => _salvar(),
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
