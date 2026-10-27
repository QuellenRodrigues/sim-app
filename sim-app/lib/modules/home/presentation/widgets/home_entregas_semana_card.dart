import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../views/home/home_state.dart';
import 'entrega_status_extension.dart';

/// Entregas da semana: calendário de segunda a domingo, ou lista.
class HomeEntregasSemanaCard extends StatelessWidget {
  const HomeEntregasSemanaCard({
    required this.periodo,
    required this.dias,
    required this.visualizacao,
    required this.onVisualizacao,
    super.key,
  });

  final String periodo;
  final List<HomeDiaSemana> dias;
  final HomeVisualizacaoEntregas visualizacao;
  final ValueChanged<HomeVisualizacaoEntregas> onVisualizacao;

  @override
  Widget build(BuildContext context) {
    return SimCard(
      titulo: 'Entregas da semana',
      subtitulo: periodo,
      acao: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SimSegmentedControl<HomeVisualizacaoEntregas>(
          opcoes: const {HomeVisualizacaoEntregas.semana: 'Semana', HomeVisualizacaoEntregas.lista: 'Lista'},
          selecionado: visualizacao,
          onChanged: onVisualizacao,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (visualizacao == HomeVisualizacaoEntregas.semana)
            _Calendario(dias: dias)
          else
            _Lista(dias: dias),
          Spacing.sm.vertical,
          const _Legenda(),
        ],
      ),
    );
  }
}

class _Calendario extends StatelessWidget {
  const _Calendario({required this.dias});

  final List<HomeDiaSemana> dias;

  static const _larguraMinima = 104.0;
  static const _espaco = 8.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cabe = constraints.maxWidth >= _larguraMinima * 7 + _espaco * 6;
        final colunas = [
          for (final (i, dia) in dias.indexed) ...[
            if (i > 0) const SizedBox(width: _espaco),
            if (cabe)
              Expanded(child: _Dia(dia: dia))
            else
              SizedBox(
                width: _larguraMinima,
                child: _Dia(dia: dia),
              ),
          ],
        ];
        final linha = IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: colunas),
        );
        return cabe ? linha : SingleChildScrollView(scrollDirection: Axis.horizontal, child: linha);
      },
    );
  }
}

class _Dia extends StatelessWidget {
  const _Dia({required this.dia});

  final HomeDiaSemana dia;

  static const _siglas = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];

  @override
  Widget build(BuildContext context) {
    final vazio = dia.entregas.isEmpty;

    return Container(
      constraints: const BoxConstraints(minHeight: 176),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: dia.hoje ? SimTokens.colorPrimary50 : SimTokens.colorNeutral50,
        borderRadius: BorderRadius.circular(SimTokens.roundedMd),
        border: dia.hoje ? Border.all(color: SimTokens.colorPrimary500, width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                dia.hoje ? 'HOJE' : _siglas[dia.data.weekday - 1],
                style: SimTypography.labelXsSemiBold.copyWith(
                  color: dia.hoje ? SimTokens.colorPrimary500 : SimTokens.colorNeutral500,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${dia.data.day}',
                style: SimTypography.titleLgMedium.copyWith(
                  color: vazio && !dia.hoje ? SimTokens.colorNeutral400 : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (vazio)
            Text(
              'Sem entregas',
              style: SimTypography.bodyXsRegular.copyWith(color: SimTokens.colorNeutral400),
            )
          else
            for (final entrega in dia.entregas) ...[
              _ChipEntrega(entrega: entrega),
              const SizedBox(height: 6),
            ],
        ],
      ),
    );
  }
}

class _ChipEntrega extends StatelessWidget {
  const _ChipEntrega({required this.entrega});

  final EntregaModel entrega;

  @override
  Widget build(BuildContext context) {
    final tipo = entrega.status.statusType;

    return Semantics(
      label: '${entrega.numero}, ${entrega.cliente}, ${entrega.status.descricao}',
      child: ExcludeSemantics(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            color: tipo.background,
            borderRadius: BorderRadius.circular(SimTokens.roundedSm),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      entrega.numero,
                      overflow: TextOverflow.ellipsis,
                      style: SimTypography.labelSmMedium.copyWith(
                        color: tipo.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (entrega.concluida) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.check, size: 12, color: tipo.foreground),
                  ],
                ],
              ),
              Text(
                entrega.cliente,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SimTypography.bodyXsRegular.copyWith(fontSize: 11, color: tipo.foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lista extends StatelessWidget {
  const _Lista({required this.dias});

  final List<HomeDiaSemana> dias;

  @override
  Widget build(BuildContext context) {
    final entregas = [
      for (final dia in dias)
        for (final entrega in dia.entregas) (dia, entrega),
    ];
    if (entregas.isEmpty) {
      return Text('Nenhuma entrega nesta semana.', style: SimTypography.bodySmRegular);
    }

    return Column(
      children: [
        for (final (i, (dia, entrega)) in entregas.indexed) ...[
          if (i > 0) const Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Spacing.xs.height),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    dia.hoje ? 'Hoje' : dia.data.diaMes,
                    style: SimTypography.bodySmSemiBold.copyWith(fontFeatures: SimTypography.tabular),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${entrega.numero} · ${entrega.cliente}',
                    overflow: TextOverflow.ellipsis,
                    style: SimTypography.bodySmRegular,
                  ),
                ),
                Spacing.xs.horizontal,
                SimStatusChip(label: entrega.status.descricao, type: entrega.status.statusType),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Legenda extends StatelessWidget {
  const _Legenda();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Wrap(
        spacing: Spacing.sm.width,
        runSpacing: Spacing.xxs.height,
        children: [
          for (final status in [
            EntregaStatus.atrasada,
            EntregaStatus.pronta,
            EntregaStatus.emProducao,
            EntregaStatus.aguardandoMaterial,
            EntregaStatus.entregue,
          ])
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: status.cor, borderRadius: BorderRadius.circular(3)),
                ),
                const SizedBox(width: 6),
                Text(status.descricao, style: SimTypography.bodyXsRegular),
              ],
            ),
        ],
      ),
    );
  }
}
