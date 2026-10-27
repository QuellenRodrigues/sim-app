import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Situação de cada máquina agora: operando, em setup ou parada, com a ocupação do dia.
class HomeMaquinasCard extends StatelessWidget {
  const HomeMaquinasCard({
    required this.maquinas,
    required this.onVerProgramacao,
    super.key,
  });

  final List<MaquinaModel> maquinas;
  final VoidCallback onVerProgramacao;

  @override
  Widget build(BuildContext context) {
    return SimCard(
      titulo: 'Máquinas agora',
      acao: SimButton(
        label: 'Programação',
        style: SimButtonStyle.texto,
        height: 44,
        onPressed: onVerProgramacao,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const espaco = 10.0;
          final colunas = constraints.maxWidth >= 840 ? 3 : (constraints.maxWidth >= 300 ? 2 : 1);
          final largura = (constraints.maxWidth - espaco * (colunas - 1)) / colunas;
          return Wrap(
            spacing: espaco,
            runSpacing: espaco,
            children: [
              for (final maquina in maquinas)
                SizedBox(
                  width: largura,
                  child: _Maquina(maquina: maquina),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Maquina extends StatelessWidget {
  const _Maquina({required this.maquina});

  final MaquinaModel maquina;

  Color get _corBarra {
    if (maquina.emSobrecarga) return SimTokens.colorError500;
    if (maquina.ocupacao >= 0.85) return SimTokens.colorWarning500;
    return SimTokens.colorPrimary500;
  }

  @override
  Widget build(BuildContext context) {
    final (corTexto, corPonto) = switch (maquina.situacao) {
      SituacaoMaquina.operando => (SimTokens.colorSuccess700, SimTokens.colorSuccess500),
      SituacaoMaquina.setup => (SimTokens.colorWarning700, SimTokens.colorWarning500),
      SituacaoMaquina.parada => (SimTokens.colorNeutral500, SimTokens.colorNeutral400),
    };
    final detalhe = maquina.ordemProducao == null ? 'sem programação' : 'OP ${maquina.ordemProducao}';
    final percentual = NumberFormatter.percentual(maquina.ocupacao);

    return Semantics(
      label: '${maquina.nome}: ${maquina.situacao.descricao}, $detalhe, $percentual da capacidade',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: maquina.emSobrecarga ? SimTokens.colorError50 : SimTokens.colorNeutral50,
            borderRadius: BorderRadius.circular(SimTokens.roundedMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maquina.nome,
                overflow: TextOverflow.ellipsis,
                style: SimTypography.bodySmSemiBold.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: corPonto, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${maquina.situacao.descricao} · $detalhe',
                      overflow: TextOverflow.ellipsis,
                      style: SimTypography.bodyXsRegular.copyWith(color: corTexto),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SimProgressBar(
                      valor: maquina.ocupacao,
                      color: _corBarra,
                      trackColor: SimTokens.colorBorder,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    percentual,
                    style: SimTypography.labelSmMedium.copyWith(
                      fontWeight: maquina.emSobrecarga ? FontWeight.w700 : FontWeight.w600,
                      color: maquina.emSobrecarga
                          ? SimTokens.colorError700
                          : (maquina.emUso ? null : SimTokens.colorNeutral500),
                      fontFeatures: SimTypography.tabular,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
