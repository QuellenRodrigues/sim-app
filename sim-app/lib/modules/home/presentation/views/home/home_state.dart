import 'package:core/core.dart';

import '../../../domain/domain.dart';

enum HomeVisualizacaoEntregas { semana, lista }

/// Um dia da faixa "Entregas da semana".
class HomeDiaSemana {
  const HomeDiaSemana({required this.data, required this.entregas, required this.hoje});

  final DateTime data;
  final List<EntregaModel> entregas;
  final bool hoje;
}

/// Valores calculados a partir do [HomePainelModel] para a tela exibir.
class HomePainelView {
  const HomePainelView({
    required this.capacidade,
    required this.maquinasEmUso,
    required this.maquinasEmSobrecarga,
    required this.entregasAteAmanha,
    required this.fraseResumo,
    required this.periodoSemana,
    required this.dias,
    required this.entregasNaSemana,
    required this.entregasConcluidasNaSemana,
    required this.emAndamento,
  });

  /// Ocupação média das máquinas em uso (0 a 1+).
  final double capacidade;
  final int maquinasEmUso;
  final int maquinasEmSobrecarga;
  final int entregasAteAmanha;
  final String fraseResumo;

  /// Ex.: "12 a 18 de outubro".
  final String periodoSemana;
  final List<HomeDiaSemana> dias;
  final int entregasNaSemana;
  final int entregasConcluidasNaSemana;

  /// Encomendas ainda não entregues, da mais urgente para a menos urgente.
  final List<EntregaModel> emAndamento;
}

class HomeState extends ViewModelState {
  factory HomeState.initial() => const HomeState();

  const HomeState({
    this.isLoading = true,
    this.saudacao = '',
    this.dataHoje = '',
    this.painel,
    this.view,
    this.mensagemErro,
    this.visualizacao = HomeVisualizacaoEntregas.semana,
  });

  final bool isLoading;
  final String saudacao;
  final String dataHoje;
  final HomePainelModel? painel;
  final HomePainelView? view;
  final String? mensagemErro;
  final HomeVisualizacaoEntregas visualizacao;

  HomeState copyWith({
    bool? isLoading,
    String? saudacao,
    String? dataHoje,
    HomePainelModel? painel,
    HomePainelView? view,
    String? mensagemErro,
    bool limparErro = false,
    HomeVisualizacaoEntregas? visualizacao,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      saudacao: saudacao ?? this.saudacao,
      dataHoje: dataHoje ?? this.dataHoje,
      painel: painel ?? this.painel,
      view: view ?? this.view,
      mensagemErro: limparErro ? null : mensagemErro ?? this.mensagemErro,
      visualizacao: visualizacao ?? this.visualizacao,
    );
  }
}
