import 'package:core/core.dart';

import '../../core_module.dart';
import 'fornecedores.dart';

class FornecedoresModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {
    // TODO: trocar pelo datasource HTTP quando a API do SIM existir.
    i.add<FornecedoresDatasource>(FornecedoresDatasourceMock.new);
    i.add<FornecedoresRepository>(FornecedoresRepositoryImpl.new);
    i.add<FornecedoresViewModel>(() => FornecedoresViewModel(i.get<FornecedoresRepository>()));
    i.add<PrecosConsultaViewModel>(() => PrecosConsultaViewModel(i.get<FornecedoresRepository>()));
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const FornecedoresPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/precos/',
      child: (_) => const PrecosConsultaPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
