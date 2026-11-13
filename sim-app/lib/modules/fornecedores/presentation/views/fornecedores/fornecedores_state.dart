import 'package:core/core.dart';

import '../../../domain/domain.dart';

/// O que o painel do formulário está mostrando.
enum FornecedoresModo { nenhum, novo, edicao }

/// Mensagem a exibir uma vez após uma ação.
///
/// Sem construtor `const` de propósito: cada aviso é um objeto novo, para que
/// duas mensagens iguais seguidas também sejam exibidas.
class FornecedoresAviso {
  FornecedoresAviso(this.texto, {required this.sucesso});

  final String texto;
  final bool sucesso;
}

class FornecedoresState extends ViewModelState {
  factory FornecedoresState.initial() => const FornecedoresState();

  const FornecedoresState({
    this.isLoading = true,
    this.busca = '',
    this.fornecedores = const [],
    this.erroLista,
    this.modo = FornecedoresModo.nenhum,
    this.selecionado,
    this.estado,
    this.inativo = false,
    this.materiais = const [],
    this.precos = const [],
    this.carregandoMateriais = false,
    this.erroMateriais,
    this.salvando = false,
    this.aviso,
  });

  final bool isLoading;
  final String busca;
  final List<FornecedorModel> fornecedores;
  final String? erroLista;
  final FornecedoresModo modo;

  /// Fornecedor aberto no formulário (no modo [FornecedoresModo.edicao]).
  final FornecedorModel? selecionado;

  /// Estado (UF) escolhido no formulário.
  final UnidadeFederativa? estado;
  final bool inativo;

  /// Materiais fornecidos pelo [selecionado].
  final List<MaterialFornecidoModel> materiais;

  /// Preços informados pelo [selecionado].
  final List<PrecoMaterialModel> precos;
  final bool carregandoMateriais;
  final String? erroMateriais;
  final bool salvando;
  final FornecedoresAviso? aviso;

  FornecedoresState copyWith({
    bool? isLoading,
    String? busca,
    List<FornecedorModel>? fornecedores,
    String? erroLista,
    bool limparErroLista = false,
    FornecedoresModo? modo,
    FornecedorModel? selecionado,
    bool limparSelecionado = false,
    UnidadeFederativa? estado,
    bool limparEstado = false,
    bool? inativo,
    List<MaterialFornecidoModel>? materiais,
    List<PrecoMaterialModel>? precos,
    bool? carregandoMateriais,
    String? erroMateriais,
    bool limparErroMateriais = false,
    bool? salvando,
    FornecedoresAviso? aviso,
  }) {
    return FornecedoresState(
      isLoading: isLoading ?? this.isLoading,
      busca: busca ?? this.busca,
      fornecedores: fornecedores ?? this.fornecedores,
      erroLista: limparErroLista ? null : erroLista ?? this.erroLista,
      modo: modo ?? this.modo,
      selecionado: limparSelecionado ? null : selecionado ?? this.selecionado,
      estado: limparEstado ? null : estado ?? this.estado,
      inativo: inativo ?? this.inativo,
      materiais: materiais ?? this.materiais,
      precos: precos ?? this.precos,
      carregandoMateriais: carregandoMateriais ?? this.carregandoMateriais,
      erroMateriais: limparErroMateriais ? null : erroMateriais ?? this.erroMateriais,
      salvando: salvando ?? this.salvando,
      aviso: aviso ?? this.aviso,
    );
  }
}
