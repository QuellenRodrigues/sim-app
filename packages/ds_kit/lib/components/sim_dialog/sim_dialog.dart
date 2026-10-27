import 'package:flutter/material.dart';

import '../../theme/tokens/tokens.dart';
import '../../theme/typography/sim_typography.dart';
import '../../theme/widgets/sim_button.dart';

/// Diálogos padrão do SIM.
abstract final class SimDialog {
  /// Pede confirmação antes de uma ação. Retorna `true` se a pessoa confirmar.
  ///
  /// ```dart
  /// final confirmou = await SimDialog.confirmar(
  ///   context,
  ///   titulo: 'Excluir cliente?',
  ///   mensagem: 'Esta ação não pode ser desfeita.',
  ///   textoConfirmar: 'Excluir',
  ///   destrutivo: true,
  /// );
  /// ```
  static Future<bool> confirmar(
    BuildContext context, {
    required String titulo,
    required String mensagem,
    String textoConfirmar = 'Confirmar',
    String textoCancelar = 'Cancelar',
    bool destrutivo = false,
  }) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: SimTokens.colorWhite,
        surfaceTintColor: SimTokens.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SimTokens.roundedLg)),
        title: Text(titulo, style: SimTypography.titleLgMedium),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            mensagem,
            style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral600),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        actions: [
          SimButton(
            label: textoCancelar,
            style: SimButtonStyle.secundario,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          SimButton(
            label: textoConfirmar,
            style: destrutivo ? SimButtonStyle.perigo : SimButtonStyle.primario,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return resultado ?? false;
  }
}
