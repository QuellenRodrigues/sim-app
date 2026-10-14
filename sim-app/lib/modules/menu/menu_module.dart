import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

import '../home/home.dart';
import 'menu.dart';

class MenuModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(MenuViewModel.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (BuildContext context) => const MenuPage(),
      children: <ParallelRoute<dynamic>>[
        ModuleRoute(
          '/inicio/',
          module: HomeModule(),
          transition: TransitionType.fadeIn,
        ),
      ],
    );
    super.routes(r);
  }
}
