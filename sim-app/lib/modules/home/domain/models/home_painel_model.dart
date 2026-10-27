import 'package:core/core.dart';

import 'alerta_model.dart';
import 'entrega_model.dart';
import 'home_resumo_model.dart';
import 'maquina_model.dart';

/// Tudo o que a home exibe, carregado de uma vez.
class HomePainelModel extends Equatable {
  const HomePainelModel({
    required this.resumo,
    required this.entregas,
    required this.maquinas,
    required this.alertas,
  });

  final HomeResumoModel resumo;

  /// Entregas da semana atual, as atrasadas e as próximas.
  final List<EntregaModel> entregas;
  final List<MaquinaModel> maquinas;
  final List<AlertaModel> alertas;

  @override
  List<Object?> get props => [resumo, entregas, maquinas, alertas];
}
