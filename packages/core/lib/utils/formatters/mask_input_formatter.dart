import 'package:flutter/services.dart';

import '../extensions/string_extensions.dart';

/// Aplica uma máscara de dígitos enquanto o usuário digita.
///
/// Na máscara, `#` é um dígito; qualquer outro caractere é fixo.
/// Com mais de uma máscara, usa a primeira que comporta a quantidade de dígitos.
class MaskInputFormatter extends TextInputFormatter {
  MaskInputFormatter(this.mascaras) : assert(mascaras.isNotEmpty);

  /// CNPJ: 00.000.000/0000-00
  factory MaskInputFormatter.cnpj() => MaskInputFormatter(['##.###.###/####-##']);

  /// CEP: 00000-000
  factory MaskInputFormatter.cep() => MaskInputFormatter(['#####-###']);

  /// Telefone fixo (10 dígitos) ou celular (11 dígitos).
  factory MaskInputFormatter.telefone() => MaskInputFormatter(['(##) ####-####', '(##) #####-####']);

  final List<String> mascaras;

  static int _digitosDa(String mascara) => '#'.allMatches(mascara).length;

  /// Formata [texto] (com ou sem máscara) usando a máscara adequada.
  String formatar(String texto) {
    final digitos = texto.somenteDigitos;
    final mascara = mascaras.firstWhere((m) => digitos.length <= _digitosDa(m), orElse: () => mascaras.last);
    final limite = _digitosDa(mascara);
    final usados = digitos.length > limite ? digitos.substring(0, limite) : digitos;

    final buffer = StringBuffer();
    var i = 0;
    for (final caractere in mascara.split('')) {
      if (i >= usados.length) break;
      if (caractere == '#') {
        buffer.write(usados[i++]);
      } else {
        buffer.write(caractere);
      }
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final formatado = formatar(newValue.text);
    return TextEditingValue(
      text: formatado,
      selection: TextSelection.collapsed(offset: formatado.length),
    );
  }
}
