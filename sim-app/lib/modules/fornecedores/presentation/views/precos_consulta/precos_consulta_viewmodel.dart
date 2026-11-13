import 'dart:async';

import 'package:core/core.dart';

import '../../../domain/domain.dart';
import 'precos_consulta_state.dart';

class PrecosConsultaViewModel extends ViewModel<PrecosConsultaState> {
  PrecosConsultaViewModel(this._repository) : super(PrecosConsultaState.initial());

  final FornecedoresRepository _repository;
  Timer? _debounce;

  /// Consulta enquanto a pessoa digita.
  void buscar(String texto, {Duration espera = const Duration(milliseconds: 300)}) {
    _debounce?.cancel();
    _debounce = Timer(espera, () {
      emit(state.copyWith(busca: texto));
      consultar();
    });
  }

  Future<void> consultar() async {
    final busca = state.busca;
    if (busca.trim().isEmpty) {
      emit(state.copyWith(grupos: const [], isLoading: false, limparErro: true));
      return;
    }

    emit(state.copyWith(isLoading: true, limparErro: true));
    final result = await _repository.consultarPrecos(busca);

    // A pessoa pode ter continuado digitando enquanto consultava.
    if (busca != state.busca) return;
    final newState = result.fold(
      (erro) => state.copyWith(erro: erro.message, grupos: const []),
      (grupos) => state.copyWith(grupos: grupos),
    );
    emit(newState.copyWith(isLoading: false));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
