import 'package:core/core.dart';

import 'fornecedor_model.dart';
import 'material_fornecido_model.dart';
import 'preco_material_model.dart';

/// Preço de um fornecedor dentro do resultado da consulta.
class OfertaModel extends Equatable {
  const OfertaModel({required this.fornecedor, required this.preco});

  final FornecedorModel fornecedor;
  final PrecoMaterialModel preco;

  @override
  List<Object?> get props => [fornecedor, preco];
}

/// Um item encontrado na consulta de preços.
class GrupoPrecosModel extends Equatable {
  const GrupoPrecosModel({
    required this.material,
    this.especificacao = '',
    this.ofertas = const [],
    this.semPreco = const [],
  });

  final MaterialFornecidoModel material;
  final String especificacao;

  /// Do menor para o maior preço, como no comparativo do SIM antigo.
  final List<OfertaModel> ofertas;

  /// Fornecem o material, mas não têm preço para este item.
  final List<FornecedorModel> semPreco;

  String get nome => [material.nome, especificacao].where((p) => p.isNotEmpty).join(' ');

  double? get menorPreco => ofertas.isEmpty ? null : ofertas.first.preco.preco;

  @override
  List<Object?> get props => [material, especificacao, ofertas, semPreco];
}
