import 'package:flutter/material.dart';

import '../../theme/tokens/tokens.dart';

/// Alterna com fade entre um indicador de carregamento e [child].
///
/// ```dart
/// SimCircularLoading(
///   loading: state.isLoading,
///   child: MeuConteudo(),
/// )
/// ```
class SimCircularLoading extends StatelessWidget {
  const SimCircularLoading({
    super.key,
    this.loading = true,
    this.child,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.color = SimTokens.colorPrimary500,
  });

  final bool loading;
  final Widget? child;
  final Duration fadeDuration;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: fadeDuration,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [...previousChildren, ?currentChild],
        );
      },
      child: loading
          ? Padding(
              key: const ValueKey('loading'),
              padding: const EdgeInsets.only(top: 120),
              child: SizedBox.square(
                dimension: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            )
          : KeyedSubtree(key: const ValueKey('content'), child: child ?? const SizedBox.shrink()),
    );
  }
}
