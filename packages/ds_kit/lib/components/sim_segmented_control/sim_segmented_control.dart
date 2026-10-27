import 'package:flutter/material.dart';

import '../../theme/tokens/tokens.dart';
import '../../theme/typography/sim_typography.dart';

/// Seletor de opções exclusivas em formato de pílula (ex.: Semana | Lista).
class SimSegmentedControl<T> extends StatelessWidget {
  const SimSegmentedControl({
    required this.opcoes,
    required this.selecionado,
    required this.onChanged,
    super.key,
  });

  /// Valor → rótulo exibido.
  final Map<T, String> opcoes;
  final T selecionado;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: SimTokens.colorNeutral100,
        borderRadius: BorderRadius.circular(SimTokens.roundedSm + 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final MapEntry(key: valor, value: rotulo) in opcoes.entries)
            _Segmento(
              rotulo: rotulo,
              selecionado: valor == selecionado,
              onTap: () => onChanged(valor),
            ),
        ],
      ),
    );
  }
}

class _Segmento extends StatelessWidget {
  const _Segmento({required this.rotulo, required this.selecionado, required this.onTap});

  final String rotulo;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selecionado,
      child: Material(
        color: selecionado ? SimTokens.colorWhite : SimTokens.transparent,
        elevation: selecionado ? 1 : 0,
        shadowColor: SimColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(SimTokens.roundedSm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SimTokens.roundedSm),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            child: Text(
              rotulo,
              style: (selecionado ? SimTypography.bodySmSemiBold : SimTypography.bodySmMedium).copyWith(
                fontSize: 13,
                color: selecionado ? SimTokens.colorNeutral800 : SimTokens.colorNeutral600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
