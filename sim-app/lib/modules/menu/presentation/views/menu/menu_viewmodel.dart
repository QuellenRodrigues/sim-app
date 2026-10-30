import 'package:core/core.dart';

import '../../utils/menu_routes_enum.dart';
import 'menu_state.dart';

class MenuViewModel extends ViewModel<MenuState> {
  MenuViewModel() : super(MenuState.initial());

  /// Marca no menu o destino correspondente à rota atual (ex.: ao recarregar a página).
  void sincronizarComRota(String path) {
    final index = MenuRoutesEnum.values.indexWhere((item) => path.startsWith(item.route));
    if (index >= 0) emit(state.copyWith(currentIndex: index));
  }

  /// Navega para o destino [index]. Retorna `false` se o módulo ainda não existe.
  bool selecionar(int index) {
    final destino = MenuRoutesEnum.values[index];
    if (!destino.disponivel) return false;
    // Dentro de uma subtela (ex.: Cadastros › Clientes), o item volta para a página inicial dele.
    if (index == state.currentIndex && Nav.path == destino.route) return true;

    emit(state.copyWith(currentIndex: index));
    Nav.navigate(destino.route);
    return true;
  }
}
