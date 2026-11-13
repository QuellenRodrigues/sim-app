import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Preços informados pelo fornecedor; são a base da consulta de preços.
class FornecedorPrecos extends StatelessWidget {
  const FornecedorPrecos({
    required this.precos,
    required this.podeAdicionar,
    required this.onAdicionar,
    required this.onEditar,
    required this.onExcluir,
    super.key,
  });

  final List<PrecoMaterialModel> precos;

  /// Só se informa preço de um material que o fornecedor fornece.
  final bool podeAdicionar;
  final VoidCallback onAdicionar;
  final ValueChanged<PrecoMaterialModel> onEditar;
  final ValueChanged<PrecoMaterialModel> onExcluir;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SimTituloSecao(titulo: 'Preços', icone: Icons.sell_outlined),
        Spacing.sm.vertical,
        if (precos.isEmpty)
          Text(
            podeAdicionar ? 'Nenhum preço informado.' : 'Adicione um material para informar o preço dele.',
            style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
          ),
        for (final (i, preco) in precos.indexed) ...[
          if (i > 0) const Divider(height: 1),
          _LinhaPreco(
            preco: preco,
            onEditar: () => onEditar(preco),
            onExcluir: () => onExcluir(preco),
          ),
        ],
        if (podeAdicionar) ...[
          Spacing.sm.vertical,
          Align(
            alignment: Alignment.centerLeft,
            child: SimButton(
              label: 'Adicionar preço',
              icon: Icons.add,
              style: SimButtonStyle.secundario,
              onPressed: onAdicionar,
            ),
          ),
        ],
      ],
    );
  }
}

class _LinhaPreco extends StatelessWidget {
  const _LinhaPreco({required this.preco, required this.onEditar, required this.onExcluir});

  final PrecoMaterialModel preco;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    final data = preco.data;
    final detalhe = [
      if (preco.ipiPercentual > 0) 'IPI ${NumberFormatter.decimal(preco.ipiPercentual)}%',
      preco.frete.descricao,
      if (preco.condicaoPagamento.isNotEmpty) 'Pagamento ${preco.condicaoPagamento}',
      if (preco.prazoDias > 0) 'Entrega em ${preco.prazoDias} ${preco.prazoDias == 1 ? 'dia' : 'dias'}',
      if (data != null) DateFormat('dd/MM/yyyy', 'pt_BR').format(data),
    ].join(' · ');

    return InkWell(
      onTap: onEditar,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(preco.nomeItem, style: SimTypography.bodySmSemiBold),
                  Text(detalhe, style: SimTypography.bodyXsRegular),
                ],
              ),
            ),
            Spacing.xs.horizontal,
            Text(
              '${NumberFormatter.moeda(preco.preco)}/${preco.unidade}',
              style: SimTypography.bodySmSemiBold,
            ),
            IconButton(
              tooltip: 'Excluir preço',
              onPressed: onExcluir,
              icon: const Icon(Icons.delete_outline, size: 18, color: SimTokens.colorNeutral500),
            ),
          ],
        ),
      ),
    );
  }
}
