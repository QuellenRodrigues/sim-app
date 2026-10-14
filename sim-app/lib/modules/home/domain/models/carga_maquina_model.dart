import 'package:core/core.dart';

/// Ocupação programada de uma máquina no dia.
class CargaMaquinaModel extends Equatable {
  const CargaMaquinaModel({
    required this.maquina,
    required this.ocupacao,
  });

  final String maquina;

  /// Fração da capacidade do dia (1.0 = 100%). Pode passar de 1 em sobrecarga.
  final double ocupacao;

  bool get emSobrecarga => ocupacao > 1;

  @override
  List<Object?> get props => [maquina, ocupacao];
}
