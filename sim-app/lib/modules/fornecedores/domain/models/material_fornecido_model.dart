import 'package:core/core.dart';

/// Item do catálogo de materiais que um fornecedor pode fornecer.
class MaterialFornecidoModel extends Equatable {
  const MaterialFornecidoModel({required this.codigo, required this.tipo, this.descricao = ''});

  final int codigo;

  /// Barra, chapa, perfil, tubo…
  final String tipo;

  /// Redonda, quadrada, SCH. 40… Vazia nos itens que são só o tipo.
  final String descricao;

  /// "TUBO SCH. 40", como no sistema antigo.
  String get nome => [tipo, descricao].where((p) => p.isNotEmpty).join(' ');

  @override
  List<Object?> get props => [codigo, tipo, descricao];
}
