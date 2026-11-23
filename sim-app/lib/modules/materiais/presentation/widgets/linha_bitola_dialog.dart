import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Diálogo para incluir ou editar uma linha da tabela de bitolas: um campo por coluna.
class LinhaBitolaDialog extends StatefulWidget {
  const LinhaBitolaDialog({required this.colunas, required this.onSalvar, super.key, this.linha});

  final List<String> colunas;

  /// `null` para incluir.
  final LinhaBitolaModel? linha;

  /// Salva a linha; retorna `true` se deu certo, e então o diálogo fecha.
  final Future<bool> Function(LinhaBitolaModel linha) onSalvar;

  static Future<void> mostrar(
    BuildContext context, {
    required List<String> colunas,
    required Future<bool> Function(LinhaBitolaModel linha) onSalvar,
    LinhaBitolaModel? linha,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => LinhaBitolaDialog(colunas: colunas, linha: linha, onSalvar: onSalvar),
    );
  }

  @override
  State<LinhaBitolaDialog> createState() => _LinhaBitolaDialogState();
}

class _LinhaBitolaDialogState extends State<LinhaBitolaDialog> {
  late final _controllers = [
    for (var i = 0; i < widget.colunas.length; i++) TextEditingController(text: widget.linha?.valor(i)),
  ];
  bool _salvando = false;

  Future<void> _salvar() async {
    if (_salvando) return;
    setState(() => _salvando = true);
    final salvou = await widget.onSalvar(
      LinhaBitolaModel(codigo: widget.linha?.codigo, valores: [for (final c in _controllers) c.text.trim()]),
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
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SimTokens.colorWhite,
      surfaceTintColor: SimTokens.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SimTokens.roundedLg)),
      title: Text(
        widget.linha == null ? 'Adicionar linha' : 'Editar linha',
        style: SimTypography.titleLgMedium,
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: Spacing.sm.width,
            runSpacing: Spacing.sm.height,
            children: [
              for (final (i, coluna) in widget.colunas.indexed)
                SizedBox(
                  width: 212,
                  child: SimTextField(
                    label: coluna,
                    controller: _controllers[i],
                    autofocus: i == 0,
                    maxLength: 40,
                    textInputAction: i == widget.colunas.length - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    onSubmitted: i == widget.colunas.length - 1 ? (_) => _salvar() : null,
                  ),
                ),
            ],
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
