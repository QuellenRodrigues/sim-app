import 'package:flutter/material.dart';

import '../../theme/tokens/tokens.dart';
import '../../theme/typography/sim_typography.dart';

/// Tom semântico de status.
enum SimStatusType {
  sucesso(SimTokens.colorSuccess700, SimTokens.colorSuccess100),
  alerta(SimTokens.colorWarning700, SimTokens.colorWarning100),
  erro(SimTokens.colorError700, SimTokens.colorError100),
  info(SimTokens.colorInfo700, SimTokens.colorInfo100),
  neutro(SimTokens.colorNeutral600, SimTokens.colorNeutral100);

  const SimStatusType(this.foreground, this.background);

  final Color foreground;
  final Color background;
}

/// Etiqueta compacta de status (entregue, em produção, atrasada…).
class SimStatusChip extends StatelessWidget {
  const SimStatusChip({
    required this.label,
    super.key,
    this.type = SimStatusType.neutro,
  });

  final String label;
  final SimStatusType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: type.background,
        borderRadius: BorderRadius.circular(SimTokens.rounded2xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: type.foreground, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: SimTypography.labelSmMedium.copyWith(color: type.foreground)),
        ],
      ),
    );
  }
}
