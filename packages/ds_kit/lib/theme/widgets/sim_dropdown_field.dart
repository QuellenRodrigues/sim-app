import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import '../typography/sim_typography.dart';
import 'sim_text_field.dart';

/// Campo de seleção do SIM, com rótulo acima.
class SimDropdownField<T> extends StatelessWidget {
  const SimDropdownField({
    required this.label,
    required this.itens,
    required this.valor,
    required this.onChanged,
    super.key,
    this.hint,
    this.validator,
    this.obrigatorio = false,
  });

  final String label;

  /// Valor → texto exibido.
  final Map<T, String> itens;
  final T? valor;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final FormFieldValidator<T>? validator;
  final bool obrigatorio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SimFieldLabel(label, obrigatorio: obrigatorio),
        DropdownButtonFormField<T>(
          initialValue: valor,
          key: ValueKey(valor),
          isExpanded: true,
          validator: validator,
          onChanged: onChanged,
          style: SimTypography.bodySmRegular,
          icon: const Icon(Icons.expand_more, size: 20, color: SimTokens.colorNeutral500),
          borderRadius: BorderRadius.circular(SimTokens.roundedSm),
          menuMaxHeight: 360,
          hint: hint == null
              ? null
              : Text(hint!, style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500)),
          decoration: const InputDecoration(
            constraints: BoxConstraints(minHeight: 44),
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          items: [
            for (final MapEntry(key: valor, value: texto) in itens.entries)
              DropdownMenuItem<T>(
                value: valor,
                child: Text(texto, overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
      ],
    );
  }
}
