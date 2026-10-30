import 'package:core/core.dart';

import '../../../domain/domain.dart';

/// Mensagem a exibir uma vez após salvar ou excluir.
///
/// Sem construtor `const` de propósito: cada aviso é um objeto novo, para que
/// duas mensagens iguais seguidas também sejam exibidas.
class TabelasAuxiliaresAviso {
  TabelasAuxiliaresAviso(this.texto, {required this.sucesso});

  final String texto;
  final bool sucesso;
}

class TabelasAuxiliaresState extends ViewModelState {
  factory TabelasAuxiliaresState.initial() => const TabelasAuxiliaresState();

  const TabelasAuxiliaresState({
    this.tabela = TabelaAuxiliar.gruposMaquina,
    this.isLoading = true,
    this.itens = const [],
    this.busca = '',
    this.erro,
    this.salvando = false,
    this.aviso,
  });

  final TabelaAuxiliar tabela;
  final bool isLoading;

  /// Todos os itens da [tabela]; a tela mostra [itensFiltrados].
  final List<ItemTabelaModel> itens;
  final String busca;
  final String? erro;
  final bool salvando;
  final TabelasAuxiliaresAviso? aviso;

  /// Itens cuja descrição ou código contém a [busca], sem diferenciar acentos.
  List<ItemTabelaModel> get itensFiltrados {
    final termo = busca.trim().normalizado;
    if (termo.isEmpty) return itens;
    return itens
        .where((item) => item.descricao.normalizado.contains(termo) || item.codigoFormatado.contains(termo))
        .toList();
  }

  TabelasAuxiliaresState copyWith({
    TabelaAuxiliar? tabela,
    bool? isLoading,
    List<ItemTabelaModel>? itens,
    String? busca,
    String? erro,
    bool limparErro = false,
    bool? salvando,
    TabelasAuxiliaresAviso? aviso,
  }) {
    return TabelasAuxiliaresState(
      tabela: tabela ?? this.tabela,
      isLoading: isLoading ?? this.isLoading,
      itens: itens ?? this.itens,
      busca: busca ?? this.busca,
      erro: limparErro ? null : erro ?? this.erro,
      salvando: salvando ?? this.salvando,
      aviso: aviso ?? this.aviso,
    );
  }
}
