import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import 'entrega_status_extension.dart';

/// Encomendas ainda não entregues, com a etapa e o avanço da produção.
class HomeEmAndamentoCard extends StatelessWidget {
  const HomeEmAndamentoCard({
    required this.entregas,
    required this.onVerEncomendas,
    super.key,
  });

  final List<EntregaModel> entregas;
  final VoidCallback onVerEncomendas;

  @override
  Widget build(BuildContext context) {
    return SimCard(
      titulo: 'Em andamento',
      acao: SimButton(
        label: 'Ver encomendas',
        style: SimButtonStyle.texto,
        height: 44,
        onPressed: onVerEncomendas,
      ),
      padding: EdgeInsets.only(top: Spacing.xs.height, bottom: Spacing.xxs.height),
      child: entregas.isEmpty
          ? Padding(
              padding: EdgeInsets.all(Spacing.md.width),
              child: Text('Nenhuma encomenda em andamento.', style: SimTypography.bodySmRegular),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final largo = constraints.maxWidth >= 640;
                return Column(
                  children: [
                    for (final entrega in entregas) ...[
                      const Divider(color: SimTokens.colorNeutral100),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Spacing.md.width, vertical: 14),
                        child: largo ? _LinhaLarga(entrega: entrega) : _LinhaEstreita(entrega: entrega),
                      ),
                    ],
                  ],
                );
              },
            ),
    );
  }
}

String _prazo(EntregaModel entrega) {
  final hoje = DateTime.now().dateOnly;
  final dias = entrega.dataEntrega.dateOnly.difference(hoje).inDays;
  if (entrega.status == EntregaStatus.atrasada) return 'venceu ${entrega.dataEntrega.diaMes}';
  return switch (dias) {
    0 => 'entrega hoje',
    1 => 'entrega amanhã',
    _ => 'entrega ${entrega.dataEntrega.diaMes}',
  };
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.entrega});

  final EntregaModel entrega;

  @override
  Widget build(BuildContext context) {
    final tipo = entrega.status.statusType;
    return SimAvatar(
      iniciais: SimAvatar.iniciaisDe(entrega.cliente),
      background: tipo.background,
      foreground: tipo.foreground,
    );
  }
}

class _Titulo extends StatelessWidget {
  const _Titulo({required this.entrega});

  final EntregaModel entrega;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${entrega.item} · ${NumberFormatter.inteiro(entrega.quantidade)} pç',
          overflow: TextOverflow.ellipsis,
          style: SimTypography.bodySmSemiBold,
        ),
        Text(
          '${entrega.numero} · ${entrega.cliente}',
          overflow: TextOverflow.ellipsis,
          style: SimTypography.bodyXsRegular.copyWith(color: SimTokens.colorNeutral500),
        ),
      ],
    );
  }
}

class _Progresso extends StatelessWidget {
  const _Progresso({required this.entrega});

  final EntregaModel entrega;

  @override
  Widget build(BuildContext context) {
    final percentual = NumberFormatter.percentual(entrega.progresso);
    return Semantics(
      label: '${entrega.etapa}, $percentual concluído',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entrega.etapa,
                    overflow: TextOverflow.ellipsis,
                    style: SimTypography.bodyXsRegular.copyWith(color: SimTokens.colorNeutral600),
                  ),
                ),
                Text(percentual, style: SimTypography.labelSmMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            SimProgressBar(valor: entrega.progresso, color: entrega.status.cor),
          ],
        ),
      ),
    );
  }
}

class _Situacao extends StatelessWidget {
  const _Situacao({required this.entrega, this.alinhamento = CrossAxisAlignment.end});

  final EntregaModel entrega;
  final CrossAxisAlignment alinhamento;

  @override
  Widget build(BuildContext context) {
    final atrasada = entrega.status == EntregaStatus.atrasada;
    return Column(
      crossAxisAlignment: alinhamento,
      mainAxisSize: MainAxisSize.min,
      children: [
        SimStatusChip(label: entrega.status.descricao, type: entrega.status.statusType),
        const SizedBox(height: 4),
        Text(
          _prazo(entrega),
          style:
              (atrasada
                      ? SimTypography.labelSmMedium.copyWith(fontWeight: FontWeight.w600)
                      : SimTypography.bodyXsRegular)
                  .copyWith(color: atrasada ? SimTokens.colorError700 : SimTokens.colorNeutral600),
        ),
      ],
    );
  }
}

class _LinhaLarga extends StatelessWidget {
  const _LinhaLarga({required this.entrega});

  final EntregaModel entrega;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Avatar(entrega: entrega),
        Spacing.sm.horizontal,
        Expanded(child: _Titulo(entrega: entrega)),
        Spacing.sm.horizontal,
        SizedBox(width: 180, child: _Progresso(entrega: entrega)),
        Spacing.sm.horizontal,
        SizedBox(width: 150, child: _Situacao(entrega: entrega)),
      ],
    );
  }
}

class _LinhaEstreita extends StatelessWidget {
  const _LinhaEstreita({required this.entrega});

  final EntregaModel entrega;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Avatar(entrega: entrega),
            Spacing.xs.horizontal,
            Spacing.xxs.horizontal,
            Expanded(child: _Titulo(entrega: entrega)),
          ],
        ),
        Spacing.xs.vertical,
        _Progresso(entrega: entrega),
        Spacing.xs.vertical,
        _Situacao(entrega: entrega, alinhamento: CrossAxisAlignment.start),
      ],
    );
  }
}
