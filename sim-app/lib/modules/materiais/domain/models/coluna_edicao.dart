import 'package:core/core.dart';

/// Coluna como ficou depois de editar a estrutura da tabela.
///
/// [origem] é a posição que a coluna tinha antes (`null` para coluna nova); com ela,
/// os valores das linhas acompanham a coluna quando outras são removidas.
class ColunaEdicao extends Equatable {
  const ColunaEdicao({required this.nome, this.origem});

  final String nome;
  final int? origem;

  /// Nova posição da coluna que estava em [atual]; `null` se ela foi removida ou se não havia coluna.
  static int? remapear(int? atual, List<ColunaEdicao> colunas) {
    if (atual == null) return null;
    final nova = colunas.indexWhere((c) => c.origem == atual);
    return nova < 0 ? null : nova;
  }

  @override
  List<Object?> get props => [nome, origem];
}
