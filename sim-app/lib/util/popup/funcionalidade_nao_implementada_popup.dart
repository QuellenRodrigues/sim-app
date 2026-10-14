import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Aviso padrão para telas e ações que ainda serão migradas do sistema antigo.
void mostrarFuncionalidadeNaoImplementada(BuildContext context) {
  const SimSnackBar(
    title: 'Em breve',
    message: 'Esta funcionalidade ainda não está disponível.',
    type: SimSnackBarType.warning,
  ).show(context);
}
