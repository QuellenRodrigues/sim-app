import 'package:core/core.dart';

import '../../core_module.dart';
import 'materiais.dart';

class MateriaisModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {
    // TODO: trocar pelo datasource HTTP quando a API do SIM existir.
    i.add<MateriaisDatasource>(MateriaisDatasourceMock.new);
    i.add<MateriaisRepository>(MateriaisRepositoryImpl.new);
    i.add<MateriaisViewModel>(() => MateriaisViewModel(i.get<MateriaisRepository>()));
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const MateriaisPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
