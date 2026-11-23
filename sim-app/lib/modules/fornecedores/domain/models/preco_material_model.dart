import 'package:core/core.dart';

import 'grupo_compra_model.dart';

/// Frete da cotação, com os valores usados no SIM antigo.
enum FreteCotacao {
  fob('FOB'),
  cif('CIF'),
  semFrete('Sem frete');

  const FreteCotacao(this.descricao);

  final String descricao;
}

/// Preço de um item específico em um fornecedor.
///
/// O grupo de compra é genérico ("PARAFUSOS"), por isso a [especificacao] identifica o item:
/// "M10 x 50 zincado". Os demais campos vêm do retorno de cotação
/// (tabela COMPRAS_FORNECEDOR_RETORNO_PRECO), sem ICMS e ISS, sempre zerados no banco.
class PrecoMaterialModel extends Equatable {
  const PrecoMaterialModel({
    required this.codigoFornecedor,
    required this.grupo,
    required this.especificacao,
    required this.unidade,
    required this.preco,
    this.codigo,
    this.ipiPercentual = 0,
    this.frete = FreteCotacao.fob,
    this.condicaoPagamento = '',
    this.prazoDias = 0,
    this.data,
  });

  /// `null` enquanto o preço não foi salvo.
  final int? codigo;
  final int codigoFornecedor;
  final GrupoCompraModel grupo;
  final String especificacao;

  /// Unidade do preço: UN, KG, M…
  final String unidade;
  final double preco;

  /// IPI em porcentagem (5 = 5%), como no banco antigo.
  final double ipiPercentual;
  final FreteCotacao frete;

  /// Dias de pagamento, como no SIM: "30/45/60".
  final String condicaoPagamento;

  /// Prazo de entrega em dias.
  final int prazoDias;

  /// Quando o preço foi informado; preenchida ao salvar.
  final DateTime? data;

  /// "PARAFUSOS M10 x 50 zincado", ou só o grupo, se não houver especificação.
  String get nomeItem => [grupo.nome, especificacao].where((p) => p.isNotEmpty).join(' ');

  PrecoMaterialModel copyWith({int? codigo, DateTime? data, String? especificacao}) {
    return PrecoMaterialModel(
      codigo: codigo ?? this.codigo,
      codigoFornecedor: codigoFornecedor,
      grupo: grupo,
      especificacao: especificacao ?? this.especificacao,
      unidade: unidade,
      preco: preco,
      ipiPercentual: ipiPercentual,
      frete: frete,
      condicaoPagamento: condicaoPagamento,
      prazoDias: prazoDias,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
    codigo,
    codigoFornecedor,
    grupo,
    especificacao,
    unidade,
    preco,
    ipiPercentual,
    frete,
    condicaoPagamento,
    prazoDias,
    data,
  ];
}
