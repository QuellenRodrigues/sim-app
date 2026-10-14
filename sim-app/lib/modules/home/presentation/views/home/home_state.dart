import 'package:core/core.dart';

import '../../../domain/domain.dart';

class HomeState extends ViewModelState {
  factory HomeState.initial() => const HomeState();

  const HomeState({
    this.isLoading = true,
    this.saudacao = '',
    this.dataHoje = '',
    this.painel,
    this.mensagemErro,
  });

  final bool isLoading;
  final String saudacao;
  final String dataHoje;
  final HomePainelModel? painel;
  final String? mensagemErro;

  HomeState copyWith({
    bool? isLoading,
    String? saudacao,
    String? dataHoje,
    HomePainelModel? painel,
    String? mensagemErro,
    bool limparErro = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      saudacao: saudacao ?? this.saudacao,
      dataHoje: dataHoje ?? this.dataHoje,
      painel: painel ?? this.painel,
      mensagemErro: limparErro ? null : mensagemErro ?? this.mensagemErro,
    );
  }
}
