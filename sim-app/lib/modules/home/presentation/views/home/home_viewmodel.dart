import 'package:core/core.dart';

import '../../../domain/domain.dart';
import 'home_state.dart';

class HomeViewModel extends ViewModel<HomeState> {
  HomeViewModel(this._repository, {DateTime Function()? agora})
    : _agora = agora ?? DateTime.now,
      super(HomeState.initial());

  final HomeRepository _repository;
  final DateTime Function() _agora;

  @override
  void initViewModel() {
    super.initViewModel();
    _definirCabecalho();
    carregarPainel();
  }

  void _definirCabecalho() {
    final agora = _agora();
    final saudacao = switch (agora.hour) {
      < 12 => 'Bom dia',
      < 18 => 'Boa tarde',
      _ => 'Boa noite',
    };
    emit(state.copyWith(saudacao: saudacao, dataHoje: agora.extenso.toCapitalized()));
  }

  Future<void> carregarPainel() async {
    emit(state.copyWith(isLoading: true, limparErro: true));

    final result = await _repository.carregarPainel();

    final newState = result.fold(
      (erro) => state.copyWith(mensagemErro: erro.message),
      (painel) => state.copyWith(painel: painel),
    );
    emit(newState.copyWith(isLoading: false));
  }
}
