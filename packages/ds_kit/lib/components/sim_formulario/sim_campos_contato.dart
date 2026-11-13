import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Campo de telefone com máscara e validação.
class SimTelefoneField extends StatelessWidget {
  const SimTelefoneField({required this.label, required this.controller, super.key});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SimTextField(
      label: label,
      hint: '(00) 0000-0000',
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [MaskInputFormatter.telefone()],
      validator: SimValidatorless.telefone(),
    );
  }
}

/// Campo de e-mail com validação e o tamanho do banco do SIM.
class SimEmailField extends StatelessWidget {
  const SimEmailField({required this.label, required this.controller, super.key});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SimTextField(
      label: label,
      hint: 'nome@empresa.com.br',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      maxLength: 50,
      validator: SimValidatorless.email(),
    );
  }
}
