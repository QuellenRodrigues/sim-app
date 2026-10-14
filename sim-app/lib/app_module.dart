import 'package:core/core.dart';

import 'core_module.dart';
import 'modules/menu/menu.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.module(
      '/menu',
      module: MenuModule(),
      transition: TransitionType.fadeIn,
    );
  }
}
