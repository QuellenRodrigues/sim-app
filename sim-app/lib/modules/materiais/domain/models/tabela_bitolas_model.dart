import 'package:core/core.dart';

/// Unidade da tabela no SIM antigo. Ela só era exibida; nenhum cálculo a usava.
enum UnidadeTabela {
  volume('Volume'),
  kg('Kg');

  const UnidadeTabela(this.descricao);

  final String descricao;

  static UnidadeTabela de(String valor) =>
      values.firstWhere((u) => u.descricao.toLowerCase() == valor.toLowerCase(), orElse: () => volume);
}

/// Uma bitola: os valores seguem a ordem das colunas da tabela.
class LinhaBitolaModel extends Equatable {
  const LinhaBitolaModel({required this.valores, this.codigo});

  /// `null` enquanto a linha não foi salva.
  final int? codigo;
  final List<String> valores;

  /// Valor da [coluna], ou vazio se a linha não tiver essa coluna.
  String valor(int coluna) => coluna < valores.length ? valores[coluna] : '';

  @override
  List<Object?> get props => [codigo, valores];
}

/// Tabela de bitolas de um material: até 20 colunas definidas por material, como no SIM antigo.
class TabelaBitolasModel extends Equatable {
  const TabelaBitolasModel({
    this.nome = '',
    this.unidade = UnidadeTabela.volume,
    this.colunas = const [],
    this.linhas = const [],
  });

  static const maximoColunas = 20;

  final String nome;
  final UnidadeTabela unidade;
  final List<String> colunas;

  /// Na ordem em que aparecem no orçamento.
  final List<LinhaBitolaModel> linhas;

  bool get temColunas => colunas.isNotEmpty;

  @override
  List<Object?> get props => [nome, unidade, colunas, linhas];
}
