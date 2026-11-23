import 'package:core/core.dart';

/// Medidas que o orçamento pede ao usar o material (DIAMETRO, LARGURA, COMPRIMENTO e PESO no SIM antigo).
enum MedidaOrcamento {
  diametro('Diâmetro/bitola'),
  largura('Largura'),
  comprimento('Comprimento'),
  peso('Peso');

  const MedidaOrcamento(this.descricao);

  final String descricao;
}

/// Grupo do material: barra, chapa, perfil, tubo… (tabela TIPO_MATERIAL).
class GrupoMaterialModel extends Equatable {
  const GrupoMaterialModel({required this.codigo, required this.nome});

  final int codigo;
  final String nome;

  @override
  List<Object?> get props => [codigo, nome];
}

/// Material do catálogo, com as opções que o orçamento usa (tabela MATERIAIS).
class MaterialModel extends Equatable {
  const MaterialModel({
    required this.grupo,
    this.codigo,
    this.descricao = '',
    this.medidas = const {},
    this.colunaBitola,
    this.valorZero = false,
    this.descricaoEmBranco = false,
    this.exibirNoSubitem = true,
    this.quantidadeBitolas = 0,
  });

  /// `null` enquanto o material não foi salvo.
  final int? codigo;
  final GrupoMaterialModel grupo;

  /// Subgrupo no SIM antigo: "REDONDA", "SCH. 40"… Pode ficar vazia.
  final String descricao;
  final Set<MedidaOrcamento> medidas;

  /// Coluna da tabela de bitolas que o orçamento copia para "Diâmetro/bitola"; `null` para nenhuma.
  final int? colunaBitola;

  /// No orçamento, o material entra com valor zero.
  final bool valorZero;
  final bool descricaoEmBranco;
  final bool exibirNoSubitem;

  /// Linhas da tabela de bitolas (só leitura; vem da tabela).
  final int quantidadeBitolas;

  /// "BARRA REDONDA", ou só o grupo quando não há descrição.
  String get nome => [grupo.nome, descricao].where((p) => p.isNotEmpty).join(' ');

  /// Código com 4 dígitos, como no sistema antigo (ex.: "0007").
  String get codigoFormatado => codigo == null ? '' : codigo.toString().padLeft(4, '0');

  MaterialModel copyWith({
    int? codigo,
    GrupoMaterialModel? grupo,
    String? descricao,
    Set<MedidaOrcamento>? medidas,
    int? colunaBitola,
    bool limparColunaBitola = false,
    bool? valorZero,
    bool? descricaoEmBranco,
    bool? exibirNoSubitem,
    int? quantidadeBitolas,
  }) {
    return MaterialModel(
      codigo: codigo ?? this.codigo,
      grupo: grupo ?? this.grupo,
      descricao: descricao ?? this.descricao,
      medidas: medidas ?? this.medidas,
      colunaBitola: limparColunaBitola ? null : colunaBitola ?? this.colunaBitola,
      valorZero: valorZero ?? this.valorZero,
      descricaoEmBranco: descricaoEmBranco ?? this.descricaoEmBranco,
      exibirNoSubitem: exibirNoSubitem ?? this.exibirNoSubitem,
      quantidadeBitolas: quantidadeBitolas ?? this.quantidadeBitolas,
    );
  }

  @override
  List<Object?> get props => [
    codigo,
    grupo,
    descricao,
    medidas,
    colunaBitola,
    valorZero,
    descricaoEmBranco,
    exibirNoSubitem,
    quantidadeBitolas,
  ];
}
