import 'package:core/core.dart';

/// Números consolidados dos indicadores da home.
class HomeResumoModel extends Equatable {
  const HomeResumoModel({
    required this.orcamentosEmAberto,
    required this.valorOrcamentosEmAberto,
    required this.orcamentosNovosNaSemana,
    required this.tendenciaOrcamentos,
    required this.encomendasEmProducao,
    required this.ordensProducaoAbertas,
    required this.tendenciaProducao,
    required this.encomendasAtrasadas,
    required this.diasAtrasoMaisAntiga,
    required this.tendenciaAtrasos,
  });

  final int orcamentosEmAberto;
  final double valorOrcamentosEmAberto;
  final int orcamentosNovosNaSemana;

  /// Série das últimas semanas, da mais antiga para a mais recente.
  final List<double> tendenciaOrcamentos;

  final int encomendasEmProducao;
  final int ordensProducaoAbertas;
  final List<double> tendenciaProducao;

  final int encomendasAtrasadas;
  final int diasAtrasoMaisAntiga;
  final List<double> tendenciaAtrasos;

  @override
  List<Object?> get props => [
    orcamentosEmAberto,
    valorOrcamentosEmAberto,
    orcamentosNovosNaSemana,
    tendenciaOrcamentos,
    encomendasEmProducao,
    ordensProducaoAbertas,
    tendenciaProducao,
    encomendasAtrasadas,
    diasAtrasoMaisAntiga,
    tendenciaAtrasos,
  ];
}
