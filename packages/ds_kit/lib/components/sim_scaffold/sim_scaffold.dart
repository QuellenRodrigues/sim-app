import 'package:flutter/material.dart';

import '../../theme/tokens/tokens.dart';

/// [Scaffold] padrão do SIM, com o fundo neutro do sistema.
class SimScaffold extends StatelessWidget {
  const SimScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.backgroundColor = SimTokens.colorNeutral50,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}
