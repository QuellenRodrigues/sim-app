import 'package:core/core.dart';

import '../../../domain/domain.dart';

/// O que o painel do formulário está mostrando.
enum ClientesModo { nenhum, novo, edicao }

/// Mensagem a exibir uma vez após salvar ou excluir.
///
/// Sem construtor `const` de propósito: cada aviso é um objeto novo, para que
/// duas mensagens iguais seguidas também sejam exibidas.
class ClientesAviso {
  ClientesAviso(this.texto, {required this.sucesso});

  final String texto;
  final bool sucesso;
}

class ClientesState extends ViewModelState {
  factory ClientesState.initial() => const ClientesState();

  const ClientesState({
    this.isLoading = true,
    this.busca = '',
    this.clientes = const [],
    this.erroLista,
    this.modo = ClientesModo.nenhum,
    this.selecionado,
    this.estado,
    this.salvando = false,
    this.aviso,
  });

  final bool isLoading;
  final String busca;
  final List<ClienteModel> clientes;
  final String? erroLista;
  final ClientesModo modo;

  /// Cliente aberto no formulário (no modo [ClientesModo.edicao]).
  final ClienteModel? selecionado;

  /// Estado (UF) escolhido no formulário.
  final UnidadeFederativa? estado;
  final bool salvando;
  final ClientesAviso? aviso;

  ClientesState copyWith({
    bool? isLoading,
    String? busca,
    List<ClienteModel>? clientes,
    String? erroLista,
    bool limparErroLista = false,
    ClientesModo? modo,
    ClienteModel? selecionado,
    bool limparSelecionado = false,
    UnidadeFederativa? estado,
    bool limparEstado = false,
    bool? salvando,
    ClientesAviso? aviso,
  }) {
    return ClientesState(
      isLoading: isLoading ?? this.isLoading,
      busca: busca ?? this.busca,
      clientes: clientes ?? this.clientes,
      erroLista: limparErroLista ? null : erroLista ?? this.erroLista,
      modo: modo ?? this.modo,
      selecionado: limparSelecionado ? null : selecionado ?? this.selecionado,
      estado: limparEstado ? null : estado ?? this.estado,
      salvando: salvando ?? this.salvando,
      aviso: aviso ?? this.aviso,
    );
  }
}
