import 'dart:math' as math;

import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Faixa de destaque no topo da home: saudação, resumo do dia e capacidade da fábrica.
///
/// As faixas diagonais ao fundo vêm da tela de abertura do SIM original.
class HomeDestaque extends StatelessWidget {
  const HomeDestaque({
    required this.dataHoje,
    required this.saudacao,
    required this.onNovoOrcamento,
    required this.onVerProgramacao,
    super.key,
    this.fraseResumo,
    this.capacidade,
    this.maquinasEmUso = 0,
    this.maquinasEmSobrecarga = 0,
    this.entregasAteAmanha = 0,
  });

  final String dataHoje;
  final String saudacao;

  /// Nulos enquanto o painel carrega.
  final String? fraseResumo;
  final double? capacidade;

  final int maquinasEmUso;
  final int maquinasEmSobrecarga;
  final int entregasAteAmanha;
  final VoidCallback onNovoOrcamento;
  final VoidCallback onVerProgramacao;

  @override
  Widget build(BuildContext context) {
    final compacto = context.screenWidth < SimBreakpoints.compacto;

    return ClipRRect(
      borderRadius: BorderRadius.circular(SimTokens.roundedLg + 4),
      child: ColoredBox(
        color: SimTokens.colorHighlight,
        child: Stack(
          children: [
            const Positioned(
              top: -120,
              right: 120,
              child: _Faixa(largura: 70, cor: SimTokens.colorHighlightSurface),
            ),
            const Positioned(
              top: -90,
              right: 30,
              child: _Faixa(largura: 54, cor: SimTokens.colorHighlightStripe),
            ),
            const Positioned(
              top: -60,
              right: -50,
              child: _Faixa(largura: 40, cor: SimTokens.colorHighlightBorder),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compacto ? Spacing.sm.width + 4 : Spacing.lg.width + 4,
                vertical: compacto ? Spacing.md.height : Spacing.lg.height,
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: Spacing.md.width,
                runSpacing: Spacing.md.height,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: _Saudacao(
                      dataHoje: dataHoje,
                      saudacao: saudacao,
                      fraseResumo: fraseResumo,
                      onNovoOrcamento: onNovoOrcamento,
                      onVerProgramacao: onVerProgramacao,
                    ),
                  ),
                  if (capacidade != null)
                    _PainelCapacidade(
                      capacidade: capacidade!,
                      maquinasEmUso: maquinasEmUso,
                      maquinasEmSobrecarga: maquinasEmSobrecarga,
                      entregasAteAmanha: entregasAteAmanha,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Faixa extends StatelessWidget {
  const _Faixa({required this.largura, required this.cor});

  final double largura;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          width: largura,
          height: 420,
          decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(largura * 0.6)),
        ),
      ),
    );
  }
}

class _Saudacao extends StatelessWidget {
  const _Saudacao({
    required this.dataHoje,
    required this.saudacao,
    required this.fraseResumo,
    required this.onNovoOrcamento,
    required this.onVerProgramacao,
  });

  final String dataHoje;
  final String saudacao;
  final String? fraseResumo;
  final VoidCallback onNovoOrcamento;
  final VoidCallback onVerProgramacao;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dataHoje.toUpperCase(),
          style: SimTypography.overlineSemiBold.copyWith(color: SimTokens.colorHighlightMuted),
        ),
        Spacing.xs.vertical,
        Text(
          saudacao.isEmpty ? '' : '$saudacao!',
          style: SimTypography.displayXlLight.copyWith(color: SimTokens.colorWhite),
        ),
        Spacing.xs.vertical,
        Text(
          fraseResumo ?? 'Carregando o resumo da fábrica…',
          style: SimTypography.bodyMdRegular.copyWith(color: SimTokens.colorHighlightText),
        ),
        Spacing.md.vertical,
        Wrap(
          spacing: Spacing.xs.width,
          runSpacing: Spacing.xs.height,
          children: [
            SimButton(
              label: 'Novo orçamento',
              style: SimButtonStyle.claro,
              height: 44,
              onPressed: onNovoOrcamento,
            ),
            SimButton(
              label: 'Ver programação',
              style: SimButtonStyle.contornoClaro,
              height: 44,
              onPressed: onVerProgramacao,
            ),
          ],
        ),
      ],
    );
  }
}

class _PainelCapacidade extends StatelessWidget {
  const _PainelCapacidade({
    required this.capacidade,
    required this.maquinasEmUso,
    required this.maquinasEmSobrecarga,
    required this.entregasAteAmanha,
  });

  final double capacidade;
  final int maquinasEmUso;
  final int maquinasEmSobrecarga;
  final int entregasAteAmanha;

  String _plural(int n, String singular, String plural) => '$n ${n == 1 ? singular : plural}';

  @override
  Widget build(BuildContext context) {
    final percentual = NumberFormatter.percentual(capacidade);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Spacing.md.width, vertical: Spacing.sm.height + 4),
      decoration: BoxDecoration(
        color: SimTokens.colorHighlightSurface,
        borderRadius: BorderRadius.circular(SimTokens.roundedLg),
        border: Border.all(color: SimTokens.colorHighlightBorder),
      ),
      child: Wrap(
        spacing: Spacing.md.width,
        runSpacing: Spacing.sm.height,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SimProgressRing(
            valor: capacidade,
            color: capacidade > 1 ? SimTokens.colorHighlightWarning : SimTokens.colorHighlightSuccess,
            trackColor: SimTokens.colorHighlightBorder,
            semanticsLabel: '$percentual da capacidade programada',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  percentual,
                  style: SimTypography.numeroLg.copyWith(color: SimTokens.colorWhite, fontSize: 30),
                ),
                Spacing.xxs.vertical,
                Text(
                  'capacidade',
                  style: SimTypography.bodyXsRegular.copyWith(color: SimTokens.colorHighlightMuted),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HOJE NA FÁBRICA',
                style: SimTypography.overlineSemiBold.copyWith(color: SimTokens.colorHighlightMuted),
              ),
              Spacing.xs.vertical,
              _Item(
                cor: SimTokens.colorHighlightSuccess,
                texto: '${_plural(maquinasEmUso, 'máquina', 'máquinas')} em uso',
              ),
              Spacing.xs.vertical,
              _Item(
                cor: SimTokens.colorHighlightWarning,
                texto: '${_plural(maquinasEmSobrecarga, 'máquina', 'máquinas')} em sobrecarga',
              ),
              Spacing.xs.vertical,
              _Item(
                cor: SimTokens.colorWhite,
                texto: '${_plural(entregasAteAmanha, 'entrega', 'entregas')} até amanhã',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.cor, required this.texto});

  final Color cor;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        Spacing.xs.horizontal,
        Text(texto, style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorHighlightText)),
      ],
    );
  }
}
