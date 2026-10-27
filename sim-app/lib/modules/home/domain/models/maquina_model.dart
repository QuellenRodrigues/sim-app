import 'package:core/core.dart';

enum SituacaoMaquina {
  operando('Operando'),
  setup('Setup'),
  parada('Parada');

  const SituacaoMaquina(this.descricao);

  final String descricao;
}

/// Situação atual e ocupação programada de uma máquina no dia.
class MaquinaModel extends Equatable {
  const MaquinaModel({
    required this.nome,
    required this.situacao,
    required this.ocupacao,
    this.ordemProducao,
  });

  final String nome;
  final SituacaoMaquina situacao;

  /// Fração da capacidade do dia (1.0 = 100%). Pode passar de 1 em sobrecarga.
  final double ocupacao;

  /// OP em execução, se houver.
  final String? ordemProducao;

  bool get emUso => situacao != SituacaoMaquina.parada;
  bool get emSobrecarga => ocupacao > 1;

  @override
  List<Object?> get props => [nome, situacao, ocupacao, ordemProducao];
}
