import 'package:core/core.dart';

import '../../../domain/domain.dart';

class PrecosConsultaState extends ViewModelState {
  factory PrecosConsultaState.initial() => const PrecosConsultaState();

  const PrecosConsultaState({
    this.busca = '',
    this.grupos = const [],
    this.isLoading = false,
    this.erro,
  });

  final String busca;
  final List<GrupoPrecosModel> grupos;
  final bool isLoading;
  final String? erro;

  PrecosConsultaState copyWith({
    String? busca,
    List<GrupoPrecosModel>? grupos,
    bool? isLoading,
    String? erro,
    bool limparErro = false,
  }) {
    return PrecosConsultaState(
      busca: busca ?? this.busca,
      grupos: grupos ?? this.grupos,
      isLoading: isLoading ?? this.isLoading,
      erro: limparErro ? null : erro ?? this.erro,
    );
  }
}
