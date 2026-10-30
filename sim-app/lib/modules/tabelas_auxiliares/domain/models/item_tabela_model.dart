import 'package:core/core.dart';

/// Um registro de uma [TabelaAuxiliar].
class ItemTabelaModel extends Equatable {
  const ItemTabelaModel({required this.descricao, this.codigo});

  /// `null` enquanto o item não foi salvo.
  final int? codigo;
  final String descricao;

  /// Código com 3 dígitos (ex.: "007").
  String get codigoFormatado => codigo == null ? '' : codigo.toString().padLeft(3, '0');

  ItemTabelaModel copyWith({int? codigo, String? descricao}) {
    return ItemTabelaModel(codigo: codigo ?? this.codigo, descricao: descricao ?? this.descricao);
  }

  @override
  List<Object?> get props => [codigo, descricao];
}
