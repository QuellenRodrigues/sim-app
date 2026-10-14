import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../../util/util.dart';
import '../../../menu.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ViewState<MenuPage, MenuViewModel> {
  @override
  void initState() {
    super.initState();
    viewModel.sincronizarComRota(Nav.path);
  }

  void _selecionar(int index) {
    final navegou = viewModel.selecionar(index);
    if (!navegou) mostrarFuncionalidadeNaoImplementada(context);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MenuViewModel, MenuState>(
      viewModel: viewModel,
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < SimBreakpoints.compacto) {
              return _layoutCelular(state);
            }

            final compacto = constraints.maxWidth < SimBreakpoints.largo;
            return SimScaffold(
              body: Row(
                children: [
                  _menu(state, compacto: compacto),
                  const Expanded(child: RouterOutlet()),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _layoutCelular(MenuState state) {
    return SimScaffold(
      appBar: AppBar(
        title: const SimLogo(height: 22),
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Abrir menu',
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        width: SimSideMenu.larguraExpandida,
        shape: const RoundedRectangleBorder(),
        child: Builder(
          builder: (context) => _menu(
            state,
            compacto: false,
            aoSelecionar: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: const RouterOutlet(),
    );
  }

  Widget _menu(MenuState state, {required bool compacto, VoidCallback? aoSelecionar}) {
    return SimSideMenu(
      compacto: compacto,
      header: compacto ? const SimLogo.simbolo(height: 30) : const SimLogo(height: 26),
      currentIndex: state.currentIndex,
      items: MenuRoutesEnum.values
          .map((item) => SimMenuOption(label: item.name, icon: item.icon, selectedIcon: item.selectedIcon))
          .toList(),
      onChanged: (index) {
        aoSelecionar?.call();
        _selecionar(index);
      },
      footer: MenuRodape(
        compacto: compacto,
        onConfiguracoes: () => mostrarFuncionalidadeNaoImplementada(context),
      ),
    );
  }
}
