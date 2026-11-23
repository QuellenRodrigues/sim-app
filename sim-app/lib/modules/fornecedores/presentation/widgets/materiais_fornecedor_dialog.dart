import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Grupos de compra para marcar vários de uma vez, como a grade do sistema antigo.
class MateriaisFornecedorDialog extends StatefulWidget {
  const MateriaisFornecedorDialog({required this.disponiveis, super.key});

  final List<GrupoCompraModel> disponiveis;

  /// Retorna os códigos marcados, ou `null` se a pessoa cancelar.
  static Future<List<int>?> mostrar(
    BuildContext context, {
    required List<GrupoCompraModel> disponiveis,
  }) {
    return showDialog<List<int>>(
      context: context,
      builder: (_) => MateriaisFornecedorDialog(disponiveis: disponiveis),
    );
  }

  @override
  State<MateriaisFornecedorDialog> createState() => _MateriaisFornecedorDialogState();
}

class _MateriaisFornecedorDialogState extends State<MateriaisFornecedorDialog> {
  final Set<int> _marcados = {};
  String _busca = '';

  List<GrupoCompraModel> get _filtrados {
    final termo = _busca.trim().normalizado;
    if (termo.isEmpty) return widget.disponiveis;
    return widget.disponiveis.where((m) => m.nome.normalizado.contains(termo)).toList();
  }

  void _alternar(int codigo) {
    setState(() {
      if (!_marcados.remove(codigo)) _marcados.add(codigo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = _filtrados;
    final total = _marcados.length;

    return AlertDialog(
      backgroundColor: SimTokens.colorWhite,
      surfaceTintColor: SimTokens.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SimTokens.roundedLg)),
      title: Text('Adicionar grupos de compra', style: SimTypography.titleLgMedium),
      content: SizedBox(
        width: 460,
        height: 420,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autofocus: true,
              onChanged: (texto) => setState(() => _busca = texto),
              textInputAction: TextInputAction.search,
              style: SimTypography.bodySmRegular,
              decoration: const InputDecoration(
                hintText: 'Buscar grupo',
                constraints: BoxConstraints(minHeight: 44),
                prefixIcon: Icon(Icons.search, size: 20, color: SimTokens.colorNeutral500),
              ),
            ),
            Spacing.xs.vertical,
            Expanded(
              child: filtrados.isEmpty
                  ? SimMensagem(
                      icone: Icons.search_off,
                      texto: widget.disponiveis.isEmpty
                          ? 'Este fornecedor já tem todos os grupos de compra.'
                          : 'Nenhum grupo encontrado.',
                    )
                  : ListView.builder(
                      itemCount: filtrados.length,
                      itemBuilder: (context, index) {
                        final material = filtrados[index];
                        return CheckboxListTile(
                          value: _marcados.contains(material.codigo),
                          onChanged: (_) => _alternar(material.codigo),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(material.nome, style: SimTypography.bodySmRegular),
                        );
                      },
                    ),
            ),
          ],
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
          label: total == 0 ? 'Adicionar' : 'Adicionar ($total)',
          icon: Icons.check,
          isActive: total > 0,
          onPressed: () => Navigator.of(context).pop(_marcados.toList()),
        ),
      ],
    );
  }
}
