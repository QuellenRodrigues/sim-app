import 'package:core/core.dart';

/// Grupo de compra que um fornecedor fornece: "PARAFUSOS", "TUBO SCH", "TRANSPORTADORAS"…
///
/// No SIM de 2017, os itens do fornecedor passaram a ser estes grupos (tabela Materiais_grupo),
/// e não mais os materiais do catálogo técnico.
class GrupoCompraModel extends Equatable {
  const GrupoCompraModel({required this.codigo, required this.nome});

  final int codigo;
  final String nome;

  @override
  List<Object?> get props => [codigo, nome];
}
