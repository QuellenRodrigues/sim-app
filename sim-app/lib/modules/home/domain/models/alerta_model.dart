import 'package:core/core.dart';

enum TipoAlerta {
  atraso(sobreEncomenda: true),
  materialPendente(sobreEncomenda: true),
  sobrecarga(sobreEncomenda: false);

  const TipoAlerta({required this.sobreEncomenda});

  /// `true` quando o alerta é de uma encomenda; `false` quando é de uma máquina.
  final bool sobreEncomenda;
}

/// Situação que pede uma ação de quem planeja a produção.
class AlertaModel extends Equatable {
  const AlertaModel({
    required this.tipo,
    required this.titulo,
    required this.descricao,
    required this.acao,
  });

  final TipoAlerta tipo;
  final String titulo;
  final String descricao;

  /// Rótulo da ação sugerida (ex.: "Renegociar data").
  final String acao;

  @override
  List<Object?> get props => [tipo, titulo, descricao, acao];
}
