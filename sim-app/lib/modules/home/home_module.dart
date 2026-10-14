import 'package:core/core.dart';

import '../../core_module.dart';
import 'home.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {
    // TODO: trocar pelo datasource HTTP quando a API do SIM existir.
    i.add<HomeDatasource>(HomeDatasourceMock.new);
    i.add<HomeRepository>(HomeRepositoryImpl.new);
    i.add<HomeViewModel>(() => HomeViewModel(i.get<HomeRepository>()));
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const HomePage(),
      transition: TransitionType.fadeIn,
    );
  }
}
