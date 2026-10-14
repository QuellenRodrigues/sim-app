import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import 'entrega_status_extension.dart';

/// Tabela das encomendas com entrega mais próxima (vira lista em telas estreitas).
class HomeProximasEntregasCard extends StatelessWidget {
  const HomeProximasEntregasCard({
    required this.entregas,
    required this.onVerEncomendas,
    super.key,
  });

  final List<EntregaModel> entregas;
  final VoidCallback onVerEncomendas;

  @override
  Widget build(BuildContext context) {
    return SimCard(
      titulo: 'Próximas entregas',
      subtitulo: 'Atrasadas e previstas para os próximos 7 dias',
      acao: SimButton(
        label: 'Ver encomendas',
        style: SimButtonStyle.texto,
        onPressed: onVerEncomendas,
      ),
      padding: EdgeInsets.only(top: Spacing.xs.height, bottom: Spacing.xs.height),
      child: entregas.isEmpty
          ? Padding(
              padding: EdgeInsets.all(Spacing.md.width),
              child: Text(
                'Nenhuma entrega prevista para os próximos dias.',
                style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral600),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final tabela = constraints.maxWidth >= 600;
                return Column(
                  children: [
                    if (tabela) const _Cabecalho(),
                    for (final entrega in entregas) ...[
                      const Divider(),
                      tabela ? _LinhaTabela(entrega: entrega) : _LinhaLista(entrega: entrega),
                    ],
                  ],
                );
              },
            ),
    );
  }
}

String _descricaoData(EntregaModel entrega) {
  final hoje = DateTime.now().dateOnly;
  final dias = entrega.dataEntrega.dateOnly.difference(hoje).inDays;
  return switch (dias) {
    0 => 'Hoje',
    1 => 'Amanhã',
    -1 => 'Ontem',
    _ => entrega.dataEntrega.diaMes,
  };
}

const _paddingLinha = EdgeInsets.symmetric(horizontal: 24, vertical: 12);

class _Cabecalho extends StatelessWidget {
  const _Cabecalho();

  @override
  Widget build(BuildContext context) {
    Text rotulo(String texto, {TextAlign? align}) =>
        Text(texto.toUpperCase(), style: SimTypography.labelXsSemiBold, textAlign: align);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
      child: Row(
        children: [
          SizedBox(width: 96, child: rotulo('Encomenda')),
          Expanded(child: rotulo('Cliente · Item')),
          SizedBox(width: 80, child: rotulo('Qtd', align: TextAlign.right)),
          const SizedBox(width: 24),
          SizedBox(width: 72, child: rotulo('Entrega')),
          SizedBox(width: 156, child: rotulo('Status')),
        ],
      ),
    );
  }
}

class _LinhaTabela extends StatelessWidget {
  const _LinhaTabela({required this.entrega});

  final EntregaModel entrega;

  @override
  Widget build(BuildContext context) {
    final atrasada = entrega.status == EntregaStatus.atrasada;

    return Padding(
      padding: _paddingLinha,
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              entrega.numero,
              style: SimTypography.bodySmSemiBold.copyWith(fontFeatures: SimTypography.tabular),
            ),
          ),
          Expanded(child: _ClienteItem(entrega: entrega)),
          SizedBox(
            width: 80,
            child: Text(
              '${NumberFormatter.inteiro(entrega.quantidade)} pç',
              textAlign: TextAlign.right,
              style: SimTypography.bodySmRegular.copyWith(fontFeatures: SimTypography.tabular),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 72,
            child: Text(
              _descricaoData(entrega),
              style: (atrasada ? SimTypography.bodySmSemiBold : SimTypography.bodySmRegular).copyWith(
                color: atrasada ? SimTokens.colorError700 : null,
                fontFeatures: SimTypography.tabular,
              ),
            ),
          ),
          SizedBox(
            width: 156,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SimStatusChip(label: entrega.status.descricao, type: entrega.status.statusType),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinhaLista extends StatelessWidget {
  const _LinhaLista({required this.entrega});

  final EntregaModel entrega;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _paddingLinha,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                entrega.numero,
                style: SimTypography.bodySmSemiBold.copyWith(fontFeatures: SimTypography.tabular),
              ),
              const Spacer(),
              SimStatusChip(label: entrega.status.descricao, type: entrega.status.statusType),
            ],
          ),
          Spacing.xxs.vertical,
          _ClienteItem(entrega: entrega),
          Spacing.xxs.vertical,
          Text(
            '${NumberFormatter.inteiro(entrega.quantidade)} pç · entrega ${_descricaoData(entrega).toLowerCase()}',
            style: SimTypography.bodyXsRegular,
          ),
        ],
      ),
    );
  }
}

class _ClienteItem extends StatelessWidget {
  const _ClienteItem({required this.entrega});

  final EntregaModel entrega;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(entrega.cliente, style: SimTypography.bodySmMedium, overflow: TextOverflow.ellipsis),
        Text(entrega.item, style: SimTypography.bodyXsRegular, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
