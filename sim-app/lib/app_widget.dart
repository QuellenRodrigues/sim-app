import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'modules/menu/menu.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute(MenuRoutesEnum.inicio.route);

    return MaterialApp.router(
      title: 'SIM — Sistema Integrado da Mecânica',
      theme: AppThemeBase.theme,
      routerConfig: Modular.routerConfig,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),
    );
  }
}
