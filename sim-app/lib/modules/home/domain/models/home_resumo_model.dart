import 'package:core/core.dart';

/// Indicadores do topo da home.
class HomeResumoModel extends Equatable {
  const HomeResumoModel({
    required this.orcamentosEmAberto,
    required this.valorOrcamentosEmAberto,
    required this.encomendasEmProducao,
    required this.entregasNaSemana,
    required this.encomendasAtrasadas,
  });

  final int orcamentosEmAberto;
  final double valorOrcamentosEmAberto;
  final int encomendasEmProducao;
  final int entregasNaSemana;
  final int encomendasAtrasadas;

  @override
  List<Object?> get props => [
    orcamentosEmAberto,
    valorOrcamentosEmAberto,
    encomendasEmProducao,
    entregasNaSemana,
    encomendasAtrasadas,
  ];
}
