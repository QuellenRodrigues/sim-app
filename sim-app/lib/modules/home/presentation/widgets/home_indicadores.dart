import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

enum HomeIndicador { orcamentos, emProducao, entregasSemana, atrasadas }

/// Indicadores do topo (4 colunas no desktop, 2 no tablet, 1 no celular).
class HomeIndicadores extends StatelessWidget {
  const HomeIndicadores({
    required this.resumo,
    required this.maquinasEmUso,
    required this.entregasNaSemana,
    required this.entregasConcluidasNaSemana,
    required this.onIndicador,
    super.key,
  });

  final HomeResumoModel resumo;
  final int maquinasEmUso;
  final int entregasNaSemana;
  final int entregasConcluidasNaSemana;
  final ValueChanged<HomeIndicador> onIndicador;

  @override
  Widget build(BuildContext context) {
    final atrasadas = resumo.encomendasAtrasadas;
    final pendentesSemana = entregasNaSemana - entregasConcluidasNaSemana;
    final fracaoSemana = entregasNaSemana == 0 ? 0.0 : entregasConcluidasNaSemana / entregasNaSemana;

    final cards = [
      _IndicadorCard(
        titulo: 'Orçamentos em aberto',
        icone: Icons.request_quote_outlined,
        cor: SimTokens.colorPrimary500,
        fundo: SimTokens.colorPrimary100,
        valor: NumberFormatter.inteiro(resumo.orcamentosEmAberto),
        destaque: _Pilula(
          texto: '+${resumo.orcamentosNovosNaSemana} na semana',
          cor: SimTokens.colorSuccess700,
          fundo: SimTokens.colorSuccess100,
        ),
        visual: SimSparkline(valores: resumo.tendenciaOrcamentos, color: SimTokens.colorPrimary500),
        rodape: '${NumberFormatter.moeda(resumo.valorOrcamentosEmAberto)} em propostas',
        onTap: () => onIndicador(HomeIndicador.orcamentos),
      ),
      _IndicadorCard(
        titulo: 'Encomendas em produção',
        icone: Icons.precision_manufacturing_outlined,
        cor: SimTokens.colorInfo700,
        fundo: SimTokens.colorInfo100,
        valor: NumberFormatter.inteiro(resumo.encomendasEmProducao),
        destaque: _Pilula(
          texto: '${resumo.ordensProducaoAbertas} OPs abertas',
          cor: SimTokens.colorInfo700,
          fundo: SimTokens.colorInfo100,
        ),
        visual: SimSparkline(valores: resumo.tendenciaProducao, color: SimTokens.colorInfo500),
        rodape: 'distribuídas em $maquinasEmUso ${maquinasEmUso == 1 ? 'máquina' : 'máquinas'}',
        onTap: () => onIndicador(HomeIndicador.emProducao),
      ),
      _IndicadorCard(
        titulo: 'Entregas nesta semana',
        icone: Icons.local_shipping_outlined,
        cor: SimTokens.colorSuccess700,
        fundo: SimTokens.colorSuccess100,
        valor: NumberFormatter.inteiro(entregasConcluidasNaSemana),
        sufixoValor: ' / $entregasNaSemana',
        destaque: _Pilula(
          texto: '${NumberFormatter.percentual(fracaoSemana)} concluído',
          cor: SimTokens.colorSuccess700,
          fundo: SimTokens.colorSuccess100,
        ),
        visual: _BarraSegmentada(total: entregasNaSemana, concluidas: entregasConcluidasNaSemana),
        rodape: pendentesSemana == 0
            ? 'todas as entregas da semana concluídas'
            : '$pendentesSemana ${pendentesSemana == 1 ? 'entrega' : 'entregas'} até domingo',
        onTap: () => onIndicador(HomeIndicador.entregasSemana),
      ),
      _IndicadorCard(
        titulo: 'Encomendas atrasadas',
        icone: atrasadas == 0 ? Icons.task_alt : Icons.schedule,
        cor: atrasadas == 0 ? SimTokens.colorSuccess700 : SimTokens.colorError700,
        fundo: atrasadas == 0 ? SimTokens.colorSuccess100 : SimTokens.colorError100,
        valor: NumberFormatter.inteiro(atrasadas),
        corValor: atrasadas == 0 ? null : SimTokens.colorError700,
        borda: atrasadas == 0 ? null : SimTokens.colorErrorBorder,
        destaque: atrasadas == 0
            ? const _Pilula(
                texto: 'tudo em dia',
                cor: SimTokens.colorSuccess700,
                fundo: SimTokens.colorSuccess100,
              )
            : const _Pilula(
                texto: 'ação necessária',
                cor: SimTokens.colorError700,
                fundo: SimTokens.colorError100,
              ),
        visual: SimSparkline(valores: resumo.tendenciaAtrasos, color: SimTokens.colorError500),
        rodape: atrasadas == 0
            ? 'nenhuma encomenda vencida'
            : 'a mais antiga venceu há ${resumo.diasAtrasoMaisAntiga} '
                  '${resumo.diasAtrasoMaisAntiga == 1 ? 'dia' : 'dias'}',
        onTap: () => onIndicador(HomeIndicador.atrasadas),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth;
        final colunas = largura >= 960 ? 4 : (largura >= 500 ? 2 : 1);
        final espaco = Spacing.sm.width;
        final larguraCard = (largura - espaco * (colunas - 1)) / colunas;

        return Wrap(
          spacing: espaco,
          runSpacing: espaco,
          children: [for (final card in cards) SizedBox(width: larguraCard, child: card)],
        );
      },
    );
  }
}

class _IndicadorCard extends StatelessWidget {
  const _IndicadorCard({
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.fundo,
    required this.valor,
    required this.destaque,
    required this.visual,
    required this.rodape,
    required this.onTap,
    this.sufixoValor,
    this.corValor,
    this.borda,
  });

  final String titulo;
  final IconData icone;
  final Color cor;
  final Color fundo;
  final String valor;
  final String? sufixoValor;
  final Color? corValor;
  final Color? borda;
  final Widget destaque;
  final Widget visual;
  final String rodape;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final raio = BorderRadius.circular(SimTokens.roundedLg);

    return Material(
      color: SimTokens.colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: raio,
        side: BorderSide(color: borda ?? SimTokens.colorBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: raio,
        hoverColor: SimTokens.colorNeutral50,
        child: Padding(
          padding: EdgeInsets.all(Spacing.sm.width + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: fundo,
                      borderRadius: BorderRadius.circular(SimTokens.roundedSm + 2),
                    ),
                    child: Icon(icone, color: cor, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      titulo,
                      overflow: TextOverflow.ellipsis,
                      style: SimTypography.bodySmMedium.copyWith(
                        fontSize: 13,
                        color: SimTokens.colorNeutral600,
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.xs.vertical,
              Spacing.xxs.vertical,
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: valor,
                      style: SimTypography.numeroLg.copyWith(color: corValor),
                      children: [
                        if (sufixoValor != null)
                          TextSpan(
                            text: sufixoValor,
                            style: SimTypography.numeroLg.copyWith(
                              fontSize: 22,
                              color: SimTokens.colorNeutral400,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Spacing.xs.horizontal,
                  Expanded(
                    child: Align(alignment: Alignment.centerRight, child: destaque),
                  ),
                ],
              ),
              Spacing.xs.vertical,
              Spacing.xxs.vertical,
              SizedBox(height: 34, child: visual),
              Spacing.xs.vertical,
              Text(rodape, style: SimTypography.bodyXsRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pilula extends StatelessWidget {
  const _Pilula({required this.texto, required this.cor, required this.fundo});

  final String texto;
  final Color cor;
  final Color fundo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: fundo, borderRadius: BorderRadius.circular(SimTokens.roundedMax)),
      child: Text(
        texto,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: SimTypography.labelSmMedium.copyWith(color: cor, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _BarraSegmentada extends StatelessWidget {
  const _BarraSegmentada({required this.total, required this.concluidas});

  final int total;
  final int concluidas;

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();
    return ExcludeSemantics(
      child: Row(
        children: [
          for (var i = 0; i < total; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: i < concluidas ? SimTokens.colorSuccess500 : SimTokens.colorNeutral200,
                  borderRadius: BorderRadius.circular(SimTokens.rounded2xs),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
