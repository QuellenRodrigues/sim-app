import 'package:core/core.dart';

import '../../core_module.dart';
import 'tabelas_auxiliares.dart';

class TabelasAuxiliaresModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {
    // TODO: trocar pelo datasource HTTP quando a API do SIM existir.
    i.add<TabelasAuxiliaresDatasource>(TabelasAuxiliaresDatasourceMock.new);
    i.add<TabelasAuxiliaresRepository>(TabelasAuxiliaresRepositoryImpl.new);
    i.add<TabelasAuxiliaresViewModel>(
      () => TabelasAuxiliaresViewModel(i.get<TabelasAuxiliaresRepository>()),
    );
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const TabelasAuxiliaresPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
