import 'package:core/core.dart';

import '../../../domain/domain.dart';
import 'tabelas_auxiliares_state.dart';

class TabelasAuxiliaresViewModel extends ViewModel<TabelasAuxiliaresState> {
  TabelasAuxiliaresViewModel(this._repository) : super(TabelasAuxiliaresState.initial());

  final TabelasAuxiliaresRepository _repository;

  @override
  void initViewModel() {
    super.initViewModel();
    carregar();
  }

  Future<void> carregar() async {
    final tabela = state.tabela;
    emit(state.copyWith(isLoading: true, limparErro: true));
    final result = await _repository.listar(tabela);

    // A pessoa pode ter trocado de tabela enquanto carregava.
    if (tabela != state.tabela) return;
    final newState = result.fold(
      (erro) => state.copyWith(erro: erro.message, itens: const []),
      (itens) => state.copyWith(itens: itens),
    );
    emit(newState.copyWith(isLoading: false));
  }

  void selecionarTabela(TabelaAuxiliar tabela) {
    if (tabela == state.tabela) return;
    emit(state.copyWith(tabela: tabela, itens: const [], busca: ''));
    carregar();
  }

  void buscar(String texto) => emit(state.copyWith(busca: texto));

  /// Inclui ou altera um item. Retorna `true` se salvou (para o diálogo fechar).
  Future<bool> salvar({required String descricao, int? codigo}) async {
    if (state.salvando) return false;
    emit(state.copyWith(salvando: true));

    final result = await _repository.salvar(
      state.tabela,
      ItemTabelaModel(codigo: codigo, descricao: descricao),
    );
    final salvou = result.fold(
      (erro) {
        emit(state.copyWith(salvando: false, aviso: TabelasAuxiliaresAviso(erro.message, sucesso: false)));
        return false;
      },
      (item) {
        emit(
          state.copyWith(
            salvando: false,
            aviso: TabelasAuxiliaresAviso('"${item.descricao}" salvo com sucesso!', sucesso: true),
          ),
        );
        return true;
      },
    );
    if (salvou) await carregar();
    return salvou;
  }

  Future<void> excluir(ItemTabelaModel item) async {
    final codigo = item.codigo;
    if (codigo == null) return;

    final result = await _repository.excluir(state.tabela, codigo);
    result.fold(
      (erro) => emit(state.copyWith(aviso: TabelasAuxiliaresAviso(erro.message, sucesso: false))),
      (_) => emit(
        state.copyWith(
          aviso: TabelasAuxiliaresAviso('"${item.descricao}" excluído com sucesso!', sucesso: true),
        ),
      ),
    );
    await carregar();
  }
}
