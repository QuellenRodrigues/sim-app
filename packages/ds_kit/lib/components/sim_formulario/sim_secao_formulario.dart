import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Grupo de campos com título; cada linha vira coluna em telas estreitas.
class SimSecaoFormulario extends StatelessWidget {
  const SimSecaoFormulario({
    required this.titulo,
    required this.icone,
    required this.linhas,
    super.key,
    this.descricao,
  });

  final String titulo;
  final IconData icone;
  final String? descricao;

  /// Linhas de campos; cada campo traz o seu `flex` na linha.
  final List<List<(Widget, int)>> linhas;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SimTituloSecao(titulo: titulo, icone: icone, descricao: descricao),
        Spacing.sm.vertical,
        SimSecaoFormularioCampos(linhas: linhas),
      ],
    );
  }
}

/// Linhas de campos de um formulário; cada linha vira coluna em telas estreitas.
class SimSecaoFormularioCampos extends StatelessWidget {
  const SimSecaoFormularioCampos({required this.linhas, super.key, this.larguraMinima = 560});

  /// Linhas de campos; cada campo traz o seu `flex` na linha.
  final List<List<(Widget, int)>> linhas;

  /// Abaixo desta largura, os campos de cada linha ficam um embaixo do outro.
  final double larguraMinima;

  @override
  Widget build(BuildContext context) {
    final espaco = Spacing.sm.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final empilhar = constraints.maxWidth < larguraMinima;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, linha) in linhas.indexed) ...[
              if (i > 0) SizedBox(height: espaco),
              if (empilhar)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (j, (campo, _)) in linha.indexed) ...[
                      if (j > 0) SizedBox(height: espaco),
                      campo,
                    ],
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (j, (campo, flex)) in linha.indexed) ...[
                      if (j > 0) SizedBox(width: espaco),
                      Expanded(flex: flex, child: campo),
                    ],
                  ],
                ),
            ],
          ],
        );
      },
    );
  }
}

/// Ícone e título de uma seção de formulário.
class SimTituloSecao extends StatelessWidget {
  const SimTituloSecao({required this.titulo, required this.icone, super.key, this.descricao});

  final String titulo;
  final IconData icone;
  final String? descricao;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: SimTokens.colorPrimary50,
            borderRadius: BorderRadius.circular(SimTokens.roundedSm),
          ),
          child: Icon(icone, size: 18, color: SimTokens.colorPrimary500),
        ),
        const SizedBox(width: 10),
        Text(titulo, style: SimTypography.titleSmSemiBold),
        if (descricao != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              descricao!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
            ),
          ),
        ],
      ],
    );
  }
}

/// Linha entre as seções de um formulário.
class SimSeparadorFormulario extends StatelessWidget {
  const SimSeparadorFormulario({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.md.height),
      child: const Divider(color: SimTokens.colorNeutral100),
    );
  }
}
