import 'package:core/core.dart';

import '../../core_module.dart';
import 'clientes.dart';

class ClientesModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {
    // TODO: trocar pelo datasource HTTP quando a API do SIM existir.
    i.add<ClientesDatasource>(ClientesDatasourceMock.new);
    i.add<ClientesRepository>(ClientesRepositoryImpl.new);
    i.add<ClientesViewModel>(() => ClientesViewModel(i.get<ClientesRepository>()));
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const ClientesPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
