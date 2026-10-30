import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../../util/util.dart';
import '../../utils/cadastros_enum.dart';
import '../../widgets/widgets.dart';

/// Página inicial de Cadastros: atalhos para cada cadastro, agrupados por área.
class CadastrosPage extends StatelessWidget {
  const CadastrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final compacto = context.screenWidth < SimBreakpoints.compacto;
    final grupos = <String, List<CadastrosEnum>>{};
    for (final cadastro in CadastrosEnum.values) {
      grupos.putIfAbsent(cadastro.grupo, () => []).add(cadastro);
    }

    return SimScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          compacto ? Spacing.sm.width : Spacing.lg.width,
          compacto ? Spacing.sm.height : Spacing.md.height + 4,
          compacto ? Spacing.sm.width : Spacing.lg.width,
          Spacing.lg.height,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('GESTÃO', style: SimTypography.overlineSemiBold),
            Spacing.xxs.vertical,
            Text('Cadastros', style: SimTypography.titleXlMedium),
            Text(
              'Informações usadas em orçamentos, encomendas, compras e na programação da fábrica.',
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
            ),
            for (final MapEntry(key: grupo, value: cadastros) in grupos.entries) ...[
              Spacing.md.vertical,
              Text(grupo.toUpperCase(), style: SimTypography.labelXsSemiBold),
              Spacing.xs.vertical,
              LayoutBuilder(
                builder: (context, constraints) {
                  final colunas = constraints.maxWidth >= 1100 ? 3 : (constraints.maxWidth >= 640 ? 2 : 1);
                  final espaco = Spacing.sm.width;
                  final largura = (constraints.maxWidth - espaco * (colunas - 1)) / colunas;
                  return Wrap(
                    spacing: espaco,
                    runSpacing: espaco,
                    children: [
                      for (final cadastro in cadastros)
                        SizedBox(
                          width: largura,
                          child: CadastroCard(
                            cadastro: cadastro,
                            onTap: () {
                              final rota = cadastro.rota;
                              if (rota == null) {
                                mostrarFuncionalidadeNaoImplementada(context);
                              } else {
                                Nav.navigate(rota);
                              }
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
