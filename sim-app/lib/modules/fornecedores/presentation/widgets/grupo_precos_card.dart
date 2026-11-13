import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Um item da consulta: fornecedores com preço e os que fornecem sem preço informado.
class GrupoPrecosCard extends StatelessWidget {
  const GrupoPrecosCard({required this.grupo, super.key});

  final GrupoPrecosModel grupo;

  @override
  Widget build(BuildContext context) {
    final ofertas = grupo.ofertas;
    final total = ofertas.length + grupo.semPreco.length;

    return Container(
      decoration: BoxDecoration(
        color: SimTokens.colorWhite,
        borderRadius: BorderRadius.circular(SimTokens.roundedLg),
        border: Border.all(color: SimTokens.colorBorder),
      ),
      padding: EdgeInsets.all(Spacing.sm.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(grupo.nome, style: SimTypography.titleSmSemiBold),
          Text(
            total == 1 ? '1 fornecedor' : '$total fornecedores',
            style: SimTypography.bodyXsRegular,
          ),
          if (ofertas.isNotEmpty) ...[
            Spacing.xs.vertical,
            LayoutBuilder(
              builder: (context, constraints) {
                final largo = constraints.maxWidth >= 760;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (largo) const _Cabecalho(),
                    for (final (i, oferta) in ofertas.indexed) ...[
                      if (i > 0 || largo) const Divider(height: 1),
                      _LinhaOferta(
                        oferta: oferta,
                        largo: largo,
                        menorPreco: ofertas.length > 1 && oferta.preco.preco == grupo.menorPreco,
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
          if (grupo.semPreco.isNotEmpty) ...[
            Spacing.xs.vertical,
            Text(
              ofertas.isEmpty ? 'Fornecem este material, sem preço informado:' : 'Sem preço para este item:',
              style: SimTypography.bodyXsRegular,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final fornecedor in grupo.semPreco)
                  SimStatusChip(
                    label: fornecedor.suspenso ? '${_nome(fornecedor)} (suspenso)' : _nome(fornecedor),
                    type: fornecedor.suspenso ? SimStatusType.alerta : SimStatusType.neutro,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _nome(FornecedorModel fornecedor) =>
      fornecedor.nomeFantasia.isEmpty ? fornecedor.razaoSocial : fornecedor.nomeFantasia;
}

const _colunas = (fornecedor: 5, preco: 4, ipi: 1, frete: 2, pagamento: 2, entrega: 2, data: 2);

class _Cabecalho extends StatelessWidget {
  const _Cabecalho();

  @override
  Widget build(BuildContext context) {
    Widget coluna(String texto, int flex) => Expanded(
      flex: flex,
      child: Text(texto, style: SimTypography.labelXsSemiBold),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          coluna('FORNECEDOR', _colunas.fornecedor),
          coluna('PREÇO', _colunas.preco),
          coluna('IPI', _colunas.ipi),
          coluna('FRETE', _colunas.frete),
          coluna('PAGAMENTO', _colunas.pagamento),
          coluna('ENTREGA', _colunas.entrega),
          coluna('DATA', _colunas.data),
        ],
      ),
    );
  }
}

class _LinhaOferta extends StatelessWidget {
  const _LinhaOferta({required this.oferta, required this.largo, required this.menorPreco});

  final OfertaModel oferta;
  final bool largo;
  final bool menorPreco;

  @override
  Widget build(BuildContext context) {
    final preco = oferta.preco;
    final fornecedor = oferta.fornecedor;
    final data = preco.data == null ? '' : DateFormat('dd/MM/yyyy', 'pt_BR').format(preco.data!);
    final entrega = preco.prazoDias == 0
        ? '—'
        : '${preco.prazoDias} ${preco.prazoDias == 1 ? 'dia' : 'dias'}';
    final ipi = preco.ipiPercentual == 0 ? '—' : '${NumberFormatter.decimal(preco.ipiPercentual)}%';
    final pagamento = preco.condicaoPagamento.isEmpty ? '—' : preco.condicaoPagamento;

    final nome = Wrap(
      spacing: 6,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(fornecedor.razaoSocial, style: SimTypography.bodySmRegular),
        if (fornecedor.suspenso) const SimStatusChip(label: 'Suspenso', type: SimStatusType.alerta),
      ],
    );
    final valor = Wrap(
      spacing: 6,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '${NumberFormatter.moeda(preco.preco)}/${preco.unidade}',
          style: SimTypography.bodySmSemiBold,
        ),
        if (menorPreco) const SimStatusChip(label: 'Menor preço', type: SimStatusType.sucesso),
      ],
    );

    if (!largo) {
      final detalhe = [
        if (preco.ipiPercentual > 0) 'IPI $ipi',
        preco.frete.descricao,
        if (preco.condicaoPagamento.isNotEmpty) 'Pagamento $pagamento',
        if (preco.prazoDias > 0) 'Entrega em $entrega',
        data,
      ].where((p) => p.isNotEmpty).join(' · ');

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            nome,
            const SizedBox(height: 2),
            valor,
            const SizedBox(height: 2),
            Text(detalhe, style: SimTypography.bodyXsRegular),
          ],
        ),
      );
    }

    Widget coluna(String texto, int flex) => Expanded(
      flex: flex,
      child: Text(texto, style: SimTypography.bodySmRegular),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: _colunas.fornecedor, child: nome),
          Expanded(flex: _colunas.preco, child: valor),
          coluna(ipi, _colunas.ipi),
          coluna(preco.frete.descricao, _colunas.frete),
          coluna(pagamento, _colunas.pagamento),
          coluna(entrega, _colunas.entrega),
          coluna(data, _colunas.data),
        ],
      ),
    );
  }
}
