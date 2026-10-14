import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

enum HomeIndicador { orcamentos, emProducao, entregasSemana, atrasadas }

/// Linha de indicadores do topo da home (4 colunas no desktop, 2 no tablet, 1 no celular).
class HomeIndicadores extends StatelessWidget {
  const HomeIndicadores({
    required this.resumo,
    required this.onIndicador,
    super.key,
  });

  final HomeResumoModel resumo;
  final ValueChanged<HomeIndicador> onIndicador;

  @override
  Widget build(BuildContext context) {
    final atrasadas = resumo.encomendasAtrasadas;
    final cards = [
      _HomeIndicadorCard(
        titulo: 'Orçamentos em aberto',
        valor: NumberFormatter.inteiro(resumo.orcamentosEmAberto),
        detalhe: '${NumberFormatter.moeda(resumo.valorOrcamentosEmAberto)} em propostas',
        icone: Icons.request_quote_outlined,
        cor: SimTokens.colorPrimary500,
        fundo: SimTokens.colorPrimary100,
        onTap: () => onIndicador(HomeIndicador.orcamentos),
      ),
      _HomeIndicadorCard(
        titulo: 'Encomendas em produção',
        valor: NumberFormatter.inteiro(resumo.encomendasEmProducao),
        detalhe: 'no chão de fábrica agora',
        icone: Icons.precision_manufacturing_outlined,
        cor: SimTokens.colorInfo500,
        fundo: SimTokens.colorInfo100,
        onTap: () => onIndicador(HomeIndicador.emProducao),
      ),
      _HomeIndicadorCard(
        titulo: 'Entregas nesta semana',
        valor: NumberFormatter.inteiro(resumo.entregasNaSemana),
        detalhe: 'previstas até domingo',
        icone: Icons.local_shipping_outlined,
        cor: SimTokens.colorSuccess500,
        fundo: SimTokens.colorSuccess100,
        onTap: () => onIndicador(HomeIndicador.entregasSemana),
      ),
      _HomeIndicadorCard(
        titulo: 'Encomendas atrasadas',
        valor: NumberFormatter.inteiro(atrasadas),
        detalhe: atrasadas == 0 ? 'tudo em dia' : 'precisam de atenção',
        icone: atrasadas == 0 ? Icons.task_alt : Icons.schedule,
        cor: atrasadas == 0 ? SimTokens.colorSuccess500 : SimTokens.colorError500,
        fundo: atrasadas == 0 ? SimTokens.colorSuccess100 : SimTokens.colorError100,
        destaque: atrasadas > 0,
        onTap: () => onIndicador(HomeIndicador.atrasadas),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth;
        final colunas = largura >= 1000 ? 4 : (largura >= 520 ? 2 : 1);
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

class _HomeIndicadorCard extends StatelessWidget {
  const _HomeIndicadorCard({
    required this.titulo,
    required this.valor,
    required this.detalhe,
    required this.icone,
    required this.cor,
    required this.fundo,
    required this.onTap,
    this.destaque = false,
  });

  final String titulo;
  final String valor;
  final String detalhe;
  final IconData icone;
  final Color cor;
  final Color fundo;
  final VoidCallback onTap;
  final bool destaque;

  @override
  Widget build(BuildContext context) {
    final raio = BorderRadius.circular(SimTokens.roundedMd);

    return Material(
      color: SimTokens.colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: raio,
        side: BorderSide(color: destaque ? cor.withValues(alpha: 0.45) : SimTokens.colorNeutral200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: raio,
        hoverColor: SimTokens.colorNeutral50,
        child: Padding(
          padding: EdgeInsets.all(Spacing.sm.width + 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: SimTypography.bodySmMedium.copyWith(color: SimTokens.colorNeutral600),
                    ),
                    Spacing.xxs.vertical,
                    Text(valor, style: SimTypography.displayMdMedium.copyWith(color: destaque ? cor : null)),
                    Spacing.xxs.vertical,
                    Text(
                      detalhe,
                      style: SimTypography.bodyXsRegular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: fundo,
                  borderRadius: BorderRadius.circular(SimTokens.roundedSm),
                ),
                child: Icon(icone, color: cor, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
