import 'package:core/core.dart';

import 'carga_maquina_model.dart';
import 'entrega_model.dart';
import 'home_resumo_model.dart';

/// Tudo o que a home exibe, carregado de uma vez.
class HomePainelModel extends Equatable {
  const HomePainelModel({
    required this.resumo,
    required this.proximasEntregas,
    required this.cargaMaquinas,
  });

  final HomeResumoModel resumo;
  final List<EntregaModel> proximasEntregas;
  final List<CargaMaquinaModel> cargaMaquinas;

  @override
  List<Object?> get props => [resumo, proximasEntregas, cargaMaquinas];
}
