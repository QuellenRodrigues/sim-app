import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/domain.dart';
import 'clientes_state.dart';

class ClientesViewModel extends ViewModel<ClientesState> {
  ClientesViewModel(this._repository) : super(ClientesState.initial());

  final ClientesRepository _repository;
  Timer? _debounce;

  final razaoSocialController = TextEditingController();
  final nomeFantasiaController = TextEditingController();
  final cnpjController = TextEditingController();
  final enderecoController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final cepController = TextEditingController();
  final contatoController = TextEditingController();
  final telefone1Controller = TextEditingController();
  final telefone2Controller = TextEditingController();
  final telefone3Controller = TextEditingController();
  final emailController = TextEditingController();
  final faxController = TextEditingController();
  final nextelController = TextEditingController();
  final nextelIdController = TextEditingController();

  List<TextEditingController> get _controllers => [
    razaoSocialController,
    nomeFantasiaController,
    cnpjController,
    enderecoController,
    bairroController,
    cidadeController,
    cepController,
    contatoController,
    telefone1Controller,
    telefone2Controller,
    telefone3Controller,
    emailController,
    faxController,
    nextelController,
    nextelIdController,
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
      (clientes) => state.copyWith(clientes: clientes),
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

  void selecionar(ClienteModel cliente) {
    razaoSocialController.text = cliente.razaoSocial;
    nomeFantasiaController.text = cliente.nomeFantasia;
    cnpjController.text = cliente.cnpj;
    enderecoController.text = cliente.endereco;
    bairroController.text = cliente.bairro;
    cidadeController.text = cliente.cidade;
    cepController.text = cliente.cep;
    contatoController.text = cliente.contato;
    telefone1Controller.text = cliente.telefone1;
    telefone2Controller.text = cliente.telefone2;
    telefone3Controller.text = cliente.telefone3;
    emailController.text = cliente.email;
    faxController.text = cliente.fax;
    nextelController.text = cliente.nextel;
    nextelIdController.text = cliente.nextelId;

    emit(
      state.copyWith(
        modo: ClientesModo.edicao,
        selecionado: cliente,
        estado: cliente.estado,
        limparEstado: cliente.estado == null,
      ),
    );
  }

  /// Limpa o formulário para cadastrar um cliente (botão "Adicionar" do sistema antigo).
  void novo() {
    _limparCampos();
    emit(state.copyWith(modo: ClientesModo.novo, limparSelecionado: true, limparEstado: true));
  }

  /// Fecha o formulário sem salvar.
  void fechar() {
    _limparCampos();
    emit(state.copyWith(modo: ClientesModo.nenhum, limparSelecionado: true, limparEstado: true));
  }

  void alterarEstado(UnidadeFederativa? estado) {
    emit(state.copyWith(estado: estado, limparEstado: estado == null));
  }

  Future<void> salvar() async {
    if (state.salvando) return;
    emit(state.copyWith(salvando: true));

    final result = await _repository.salvar(_clienteDoFormulario());

    result.fold(
      (erro) => emit(state.copyWith(salvando: false, aviso: ClientesAviso(erro.message, sucesso: false))),
      (salvo) {
        emit(
          state.copyWith(salvando: false, aviso: ClientesAviso('Cliente salvo com sucesso!', sucesso: true)),
        );
        selecionar(salvo);
      },
    );
    await carregar();
  }

  Future<void> excluir() async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null) {
      fechar();
      return;
    }

    final result = await _repository.excluir(codigo);
    result.fold(
      (erro) => emit(state.copyWith(aviso: ClientesAviso(erro.message, sucesso: false))),
      (_) {
        fechar();
        emit(state.copyWith(aviso: ClientesAviso('Cliente excluído com sucesso!', sucesso: true)));
      },
    );
    await carregar();
  }

  ClienteModel _clienteDoFormulario() {
    String texto(TextEditingController controller) => controller.text.trim();

    return ClienteModel(
      codigo: state.modo == ClientesModo.edicao ? state.selecionado?.codigo : null,
      razaoSocial: texto(razaoSocialController),
      nomeFantasia: texto(nomeFantasiaController),
      cnpj: texto(cnpjController),
      endereco: texto(enderecoController),
      bairro: texto(bairroController),
      cidade: texto(cidadeController),
      estado: state.estado,
      cep: texto(cepController),
      contato: texto(contatoController),
      telefone1: texto(telefone1Controller),
      telefone2: texto(telefone2Controller),
      telefone3: texto(telefone3Controller),
      email: texto(emailController),
      fax: texto(faxController),
      nextel: texto(nextelController),
      nextelId: texto(nextelIdController),
    );
  }

  void _limparCampos() {
    for (final controller in _controllers) {
      controller.clear();
    }
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
