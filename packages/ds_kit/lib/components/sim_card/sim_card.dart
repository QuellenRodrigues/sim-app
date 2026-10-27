import 'package:flutter/material.dart';

import '../../theme/spacing/spacing.dart';
import '../../theme/tokens/tokens.dart';
import '../../theme/typography/sim_typography.dart';

/// Superfície branca com borda, usada para agrupar conteúdo.
///
/// Com [titulo], exibe um cabeçalho com [acao] opcional à direita.
/// Use [padding] `EdgeInsets.zero` para listas que vão de borda a borda.
class SimCard extends StatelessWidget {
  const SimCard({
    required this.child,
    super.key,
    this.titulo,
    this.subtitulo,
    this.tituloSufixo,
    this.acao,
    this.padding,
    this.borderColor = SimTokens.colorBorder,
  });

  final Widget child;
  final String? titulo;
  final String? subtitulo;

  /// Widget logo após o título (ex.: contador).
  final Widget? tituloSufixo;
  final Widget? acao;
  final EdgeInsetsGeometry? padding;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final espaco = Spacing.md.width;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: SimTokens.colorWhite,
        borderRadius: BorderRadius.circular(SimTokens.roundedLg),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titulo != null)
            Padding(
              padding: EdgeInsets.fromLTRB(espaco, espaco - 4, espaco - 8, 0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: Spacing.xs.width,
                runSpacing: Spacing.xs.height,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(titulo!, style: SimTypography.titleLgMedium),
                          if (tituloSufixo != null) ...[Spacing.xs.horizontal, tituloSufixo!],
                        ],
                      ),
                      if (subtitulo != null)
                        Text(
                          subtitulo!,
                          style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
                        ),
                    ],
                  ),
                  ?acao,
                ],
              ),
            ),
          Padding(padding: padding ?? EdgeInsets.all(espaco), child: child),
        ],
      ),
    );
  }
}
