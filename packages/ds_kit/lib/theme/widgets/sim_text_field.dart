import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/tokens.dart';
import '../typography/sim_typography.dart';

/// Rótulo padrão dos campos de formulário, com asterisco quando obrigatório.
class SimFieldLabel extends StatelessWidget {
  const SimFieldLabel(this.texto, {super.key, this.obrigatorio = false});

  final String texto;
  final bool obrigatorio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          text: texto,
          children: [
            if (obrigatorio)
              TextSpan(
                text: ' *',
                style: TextStyle(color: SimTokens.colorError500),
              ),
          ],
        ),
        style: SimTypography.bodySmMedium.copyWith(fontSize: 13, color: SimTokens.colorNeutral700),
      ),
    );
  }
}

/// Campo de texto do SIM, com rótulo acima.
///
/// ```dart
/// SimTextField(
///   label: 'CNPJ',
///   controller: viewModel.cnpjController,
///   inputFormatters: [MaskInputFormatter.cnpj()],
///   validator: SimValidatorless.cnpj(),
/// )
/// ```
class SimTextField extends StatelessWidget {
  const SimTextField({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.obrigatorio = false,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.prefixIcon,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool obrigatorio;
  final int? maxLength;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  /// Chamado ao apertar Enter no campo.
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SimFieldLabel(label, obrigatorio: obrigatorio),
        TextFormField(
          controller: controller,
          validator: validator,
          inputFormatters: [
            if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
            ...?inputFormatters,
          ],
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          enabled: enabled,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          autofocus: autofocus,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: SimTypography.bodySmRegular,
          decoration: InputDecoration(
            hintText: hint,
            constraints: const BoxConstraints(minHeight: 44),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 20, color: SimTokens.colorNeutral500),
          ),
        ),
      ],
    );
  }
}
