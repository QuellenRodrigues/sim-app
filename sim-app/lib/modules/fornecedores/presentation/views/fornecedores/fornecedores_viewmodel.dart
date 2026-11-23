import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/domain.dart';
import 'fornecedores_state.dart';

class FornecedoresViewModel extends ViewModel<FornecedoresState> {
  FornecedoresViewModel(this._repository) : super(FornecedoresState.initial());

  final FornecedoresRepository _repository;
  Timer? _debounce;

  final razaoSocialController = TextEditingController();
  final nomeFantasiaController = TextEditingController();
  final cnpjController = TextEditingController();
  final inscricaoEstadualController = TextEditingController();
  final inscricaoMunicipalController = TextEditingController();
  final enderecoController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final cepController = TextEditingController();
  final contatoController = TextEditingController();
  final telefone1Controller = TextEditingController();
  final telefone2Controller = TextEditingController();
  final telefone3Controller = TextEditingController();
  final faxController = TextEditingController();
  final emailController = TextEditingController();
  final email2Controller = TextEditingController();
  final email3Controller = TextEditingController();

  List<TextEditingController> get _controllers => [
    razaoSocialController,
    nomeFantasiaController,
    cnpjController,
    inscricaoEstadualController,
    inscricaoMunicipalController,
    enderecoController,
    bairroController,
    cidadeController,
    cepController,
    contatoController,
    telefone1Controller,
    telefone2Controller,
    telefone3Controller,
    faxController,
    emailController,
    email2Controller,
    email3Controller,
  ];

  @override
  void initViewModel() {
    super.initViewModel();
    carregar();
  }

  Future<void> carregar() async {
    emit(state.copyWith(isLoading: true, limparErroLista: true));
    final result = await _repository.listar(busca: state.busca);
    final newState = result.fold(
      (erro) => state.copyWith(erroLista: erro.message),
      (fornecedores) => state.copyWith(fornecedores: fornecedores),
    );
    emit(newState.copyWith(isLoading: false));
  }

  /// Filtra a lista enquanto a pessoa digita, como no sistema antigo.
  void buscar(String texto, {Duration espera = const Duration(milliseconds: 300)}) {
    _debounce?.cancel();
    _debounce = Timer(espera, () {
      emit(state.copyWith(busca: texto));
      carregar();
    });
  }

  void selecionar(FornecedorModel fornecedor) {
    razaoSocialController.text = fornecedor.razaoSocial;
    nomeFantasiaController.text = fornecedor.nomeFantasia;
    cnpjController.text = fornecedor.cnpj;
    inscricaoEstadualController.text = fornecedor.inscricaoEstadual;
    inscricaoMunicipalController.text = fornecedor.inscricaoMunicipal;
    enderecoController.text = fornecedor.endereco;
    bairroController.text = fornecedor.bairro;
    cidadeController.text = fornecedor.cidade;
    cepController.text = fornecedor.cep;
    contatoController.text = fornecedor.contato;
    telefone1Controller.text = fornecedor.telefone1;
    telefone2Controller.text = fornecedor.telefone2;
    telefone3Controller.text = fornecedor.telefone3;
    faxController.text = fornecedor.fax;
    emailController.text = fornecedor.email;
    email2Controller.text = fornecedor.email2;
    email3Controller.text = fornecedor.email3;

    emit(
      state.copyWith(
        modo: FornecedoresModo.edicao,
        selecionado: fornecedor,
        estado: fornecedor.estado,
        limparEstado: fornecedor.estado == null,
        inativo: fornecedor.inativo,
        materiais: const [],
        precos: const [],
      ),
    );
    carregarMateriais();
  }

  /// Limpa o formulário para cadastrar um fornecedor (botão "Adicionar" do sistema antigo).
  void novo() => _limpar(FornecedoresModo.novo);

  /// Fecha o formulário sem salvar.
  void fechar() => _limpar(FornecedoresModo.nenhum);

  void alterarEstado(UnidadeFederativa? estado) {
    emit(state.copyWith(estado: estado, limparEstado: estado == null));
  }

  void alterarInativo(bool inativo) => emit(state.copyWith(inativo: inativo));

  Future<void> salvar() async {
    if (state.salvando) return;
    emit(state.copyWith(salvando: true));

    final result = await _repository.salvar(_fornecedorDoFormulario());

    result.fold(
      (erro) => emit(state.copyWith(salvando: false, aviso: FornecedoresAviso(erro.message, sucesso: false))),
      (salvo) {
        emit(
          state.copyWith(
            salvando: false,
            aviso: FornecedoresAviso('Fornecedor salvo com sucesso!', sucesso: true),
          ),
        );
        selecionar(salvo);
      },
    );
    await carregar();
  }

  /// Suspende ou reativa na hora, como no sistema antigo, sem mexer no que está sendo digitado.
  Future<void> alternarSuspensao() async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null) return;

    final result = await _repository.alternarSuspensao(codigo);
    result.fold(
      (erro) => emit(state.copyWith(aviso: FornecedoresAviso(erro.message, sucesso: false))),
      (atualizado) {
        if (state.selecionado?.codigo != codigo) return;
        emit(
          state.copyWith(
            selecionado: atualizado,
            aviso: FornecedoresAviso(
              atualizado.suspenso ? 'Fornecedor suspenso.' : 'Suspensão retirada.',
              sucesso: true,
            ),
          ),
        );
      },
    );
    await carregar();
  }

  Future<void> carregarMateriais() async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null) return;

    emit(state.copyWith(carregandoMateriais: true, limparErroMateriais: true));
    final (materiais, precos) = await (
      _repository.listarMateriais(codigo),
      _repository.listarPrecos(codigo),
    ).wait;

    // A pessoa pode ter aberto outro fornecedor enquanto carregava.
    if (state.selecionado?.codigo != codigo) return;
    final newState = materiais
        .flatMap((m) => precos.map((p) => (m, p)))
        .fold(
          (erro) => state.copyWith(erroMateriais: erro.message),
          (dados) => state.copyWith(materiais: dados.$1, precos: dados.$2),
        );
    emit(newState.copyWith(carregandoMateriais: false));
  }

  /// Catálogo sem o que o fornecedor já fornece; `null` se não conseguiu carregar.
  Future<List<GrupoCompraModel>?> materiaisDisponiveis() async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null) return null;

    final result = await _repository.listarMateriaisDisponiveis(codigo);
    return result.fold(
      (erro) {
        emit(state.copyWith(aviso: FornecedoresAviso(erro.message, sucesso: false)));
        return null;
      },
      (materiais) => materiais,
    );
  }

  Future<void> adicionarMateriais(List<int> codigosMateriais) async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null || codigosMateriais.isEmpty) return;

    final result = await _repository.adicionarMateriais(codigo, codigosMateriais);
    result.fold(
      (erro) => emit(state.copyWith(aviso: FornecedoresAviso(erro.message, sucesso: false))),
      (_) {},
    );
    await carregarMateriais();
  }

  Future<void> removerMaterial(GrupoCompraModel material) async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null) return;

    final result = await _repository.removerMaterial(codigo, material.codigo);
    result.fold(
      (erro) => emit(state.copyWith(aviso: FornecedoresAviso(erro.message, sucesso: false))),
      (_) {},
    );
    await carregarMateriais();
  }

  /// Inclui ou altera um preço. Retorna `true` se salvou (para o diálogo fechar).
  Future<bool> salvarPreco(PrecoMaterialModel preco) async {
    final result = await _repository.salvarPreco(preco);
    final salvou = result.fold(
      (erro) {
        emit(state.copyWith(aviso: FornecedoresAviso(erro.message, sucesso: false)));
        return false;
      },
      (_) {
        emit(state.copyWith(aviso: FornecedoresAviso('Preço salvo com sucesso!', sucesso: true)));
        return true;
      },
    );
    if (salvou) await carregarMateriais();
    return salvou;
  }

  Future<void> excluirPreco(PrecoMaterialModel preco) async {
    final codigo = preco.codigo;
    if (codigo == null) return;

    final result = await _repository.excluirPreco(codigo);
    result.fold(
      (erro) => emit(state.copyWith(aviso: FornecedoresAviso(erro.message, sucesso: false))),
      (_) {},
    );
    await carregarMateriais();
  }

  FornecedorModel _fornecedorDoFormulario() {
    String texto(TextEditingController controller) => controller.text.trim();
    final edicao = state.modo == FornecedoresModo.edicao;

    return FornecedorModel(
      codigo: edicao ? state.selecionado?.codigo : null,
      razaoSocial: texto(razaoSocialController),
      nomeFantasia: texto(nomeFantasiaController),
      cnpj: texto(cnpjController),
      inscricaoEstadual: texto(inscricaoEstadualController),
      inscricaoMunicipal: texto(inscricaoMunicipalController),
      endereco: texto(enderecoController),
      bairro: texto(bairroController),
      cidade: texto(cidadeController),
      estado: state.estado,
      cep: texto(cepController),
      contato: texto(contatoController),
      telefone1: texto(telefone1Controller),
      telefone2: texto(telefone2Controller),
      telefone3: texto(telefone3Controller),
      fax: texto(faxController),
      email: texto(emailController),
      email2: texto(email2Controller),
      email3: texto(email3Controller),
      inativo: state.inativo,
      suspensoEm: edicao ? state.selecionado?.suspensoEm : null,
    );
  }

  void _limpar(FornecedoresModo modo) {
    for (final controller in _controllers) {
      controller.clear();
    }
    emit(
      state.copyWith(
        modo: modo,
        limparSelecionado: true,
        limparEstado: true,
        inativo: false,
        materiais: const [],
        precos: const [],
        carregandoMateriais: false,
        limparErroMateriais: true,
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
