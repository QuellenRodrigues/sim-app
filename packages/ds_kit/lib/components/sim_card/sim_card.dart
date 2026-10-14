import 'package:flutter/material.dart';

import '../../theme/spacing/spacing.dart';
import '../../theme/tokens/tokens.dart';
import '../../theme/typography/sim_typography.dart';

/// Superfície branca com borda, usada para agrupar conteúdo.
///
/// Com [titulo], exibe um cabeçalho com [acao] opcional à direita.
class SimCard extends StatelessWidget {
  const SimCard({
    required this.child,
    super.key,
    this.titulo,
    this.subtitulo,
    this.acao,
    this.padding,
  });

  final Widget child;
  final String? titulo;
  final String? subtitulo;
  final Widget? acao;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final conteudoPadding = padding ?? EdgeInsets.all(Spacing.md.width);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: SimTokens.colorWhite,
        borderRadius: BorderRadius.circular(SimTokens.roundedMd),
        border: Border.all(color: SimTokens.colorNeutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titulo != null)
            Padding(
              padding: EdgeInsets.fromLTRB(Spacing.md.width, Spacing.sm.height, Spacing.sm.width, 0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(titulo!, style: SimTypography.titleSmSemiBold),
                          if (subtitulo != null) Text(subtitulo!, style: SimTypography.bodyXsRegular),
                        ],
                      ),
                    ),
                    ?acao,
                  ],
                ),
              ),
            ),
          Padding(padding: conteudoPadding, child: child),
        ],
      ),
    );
  }
}
