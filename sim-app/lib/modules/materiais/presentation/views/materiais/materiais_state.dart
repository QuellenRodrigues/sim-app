import 'package:core/core.dart';

import '../../../domain/domain.dart';

/// O que o painel do formulário está mostrando.
enum MateriaisModo { nenhum, novo, edicao }

/// Abas do material aberto.
enum MaterialAba { dados, tabela }

/// Mensagem a exibir uma vez após uma ação.
///
/// Sem construtor `const` de propósito: cada aviso é um objeto novo, para que
/// duas mensagens iguais seguidas também sejam exibidas.
class MateriaisAviso {
  MateriaisAviso(this.texto, {required this.sucesso});

  final String texto;
  final bool sucesso;
}

class MateriaisState extends ViewModelState {
  factory MateriaisState.initial() => const MateriaisState();

  const MateriaisState({
    this.isLoading = true,
    this.busca = '',
    this.materiais = const [],
    this.erroLista,
    this.grupos = const [],
    this.modo = MateriaisModo.nenhum,
    this.selecionado,
    this.aba = MaterialAba.dados,
    this.grupo,
    this.medidas = const {},
    this.colunaBitola,
    this.valorZero = false,
    this.descricaoEmBranco = false,
    this.exibirNoSubitem = true,
    this.tabela = const TabelaBitolasModel(),
    this.carregandoTabela = false,
    this.erroTabela,
    this.buscaTabela = '',
    this.salvando = false,
    this.aviso,
  });

  final bool isLoading;
  final String busca;
  final List<MaterialModel> materiais;
  final String? erroLista;
  final List<GrupoMaterialModel> grupos;
  final MateriaisModo modo;

  /// Material aberto no formulário (no modo [MateriaisModo.edicao]).
  final MaterialModel? selecionado;
  final MaterialAba aba;

  /// Opções escolhidas no formulário; a descrição fica no controller do ViewModel.
  final GrupoMaterialModel? grupo;
  final Set<MedidaOrcamento> medidas;
  final int? colunaBitola;
  final bool valorZero;
  final bool descricaoEmBranco;
  final bool exibirNoSubitem;

  /// Tabela de bitolas do [selecionado].
  final TabelaBitolasModel tabela;
  final bool carregandoTabela;
  final String? erroTabela;
  final String buscaTabela;
  final bool salvando;
  final MateriaisAviso? aviso;

  /// Linhas em que alguma coluna começa com o que foi buscado, sem diferenciar acentos.
  List<LinhaBitolaModel> get linhasFiltradas {
    if (buscaTabela.trim().isEmpty) return tabela.linhas;
    return tabela.linhas.where((l) => l.valores.any((v) => v.combinaCom(buscaTabela))).toList();
  }

  MateriaisState copyWith({
    bool? isLoading,
    String? busca,
    List<MaterialModel>? materiais,
    String? erroLista,
    bool limparErroLista = false,
    List<GrupoMaterialModel>? grupos,
    MateriaisModo? modo,
    MaterialModel? selecionado,
    bool limparSelecionado = false,
    MaterialAba? aba,
    GrupoMaterialModel? grupo,
    bool limparGrupo = false,
    Set<MedidaOrcamento>? medidas,
    int? colunaBitola,
    bool limparColunaBitola = false,
    bool? valorZero,
    bool? descricaoEmBranco,
    bool? exibirNoSubitem,
    TabelaBitolasModel? tabela,
    bool? carregandoTabela,
    String? erroTabela,
    bool limparErroTabela = false,
    String? buscaTabela,
    bool? salvando,
    MateriaisAviso? aviso,
  }) {
    return MateriaisState(
      isLoading: isLoading ?? this.isLoading,
      busca: busca ?? this.busca,
      materiais: materiais ?? this.materiais,
      erroLista: limparErroLista ? null : erroLista ?? this.erroLista,
      grupos: grupos ?? this.grupos,
      modo: modo ?? this.modo,
      selecionado: limparSelecionado ? null : selecionado ?? this.selecionado,
      aba: aba ?? this.aba,
      grupo: limparGrupo ? null : grupo ?? this.grupo,
      medidas: medidas ?? this.medidas,
      colunaBitola: limparColunaBitola ? null : colunaBitola ?? this.colunaBitola,
      valorZero: valorZero ?? this.valorZero,
      descricaoEmBranco: descricaoEmBranco ?? this.descricaoEmBranco,
      exibirNoSubitem: exibirNoSubitem ?? this.exibirNoSubitem,
      tabela: tabela ?? this.tabela,
      carregandoTabela: carregandoTabela ?? this.carregandoTabela,
      erroTabela: limparErroTabela ? null : erroTabela ?? this.erroTabela,
      buscaTabela: buscaTabela ?? this.buscaTabela,
      salvando: salvando ?? this.salvando,
      aviso: aviso ?? this.aviso,
    );
  }
}
