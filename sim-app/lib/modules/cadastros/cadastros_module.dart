import 'package:core/core.dart';

import '../../core_module.dart';
import 'cadastros.dart';

class CadastrosModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const CadastrosPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
