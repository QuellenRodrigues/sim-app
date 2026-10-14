import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'app_module.dart';
import 'app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR';

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
