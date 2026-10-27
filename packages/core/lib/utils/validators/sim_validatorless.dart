import 'package:flutter/widgets.dart';

import '../extensions/string_extensions.dart';

/// Validações de formulário no padrão `FormFieldValidator<String>`.
///
/// Os validadores de formato aceitam campo vazio; combine com [obrigatorio]
/// usando [multiplos] quando o campo for exigido.
class SimValidatorless {
  SimValidatorless._();

  static FormFieldValidator<String> obrigatorio([String mensagem = 'Campo obrigatório']) {
    return (value) => (value == null || value.trim().isEmpty) ? mensagem : null;
  }

  static FormFieldValidator<String> cnpj([String mensagem = 'CNPJ inválido']) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      return cnpjValido(value) ? null : mensagem;
    };
  }

  static FormFieldValidator<String> cep([String mensagem = 'CEP inválido']) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      return value.somenteDigitos.length == 8 ? null : mensagem;
    };
  }

  static FormFieldValidator<String> telefone([String mensagem = 'Telefone inválido']) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final digitos = value.somenteDigitos.length;
      return digitos == 10 || digitos == 11 ? null : mensagem;
    };
  }

  static FormFieldValidator<String> email([String mensagem = 'E-mail inválido']) {
    final padrao = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      return padrao.hasMatch(value.trim()) ? null : mensagem;
    };
  }

  /// Retorna o primeiro erro entre os [validadores].
  static FormFieldValidator<String> multiplos(List<FormFieldValidator<String>> validadores) {
    return (value) {
      for (final validador in validadores) {
        final erro = validador(value);
        if (erro != null) return erro;
      }
      return null;
    };
  }

  /// Confere os dígitos verificadores de um CNPJ (com ou sem máscara).
  static bool cnpjValido(String valor) {
    final digitos = valor.somenteDigitos;
    if (digitos.length != 14 || RegExp(r'^(\d)\1{13}$').hasMatch(digitos)) return false;

    int digito(String base) {
      final pesos = base.length == 12
          ? [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
          : [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
      var soma = 0;
      for (var i = 0; i < base.length; i++) {
        soma += int.parse(base[i]) * pesos[i];
      }
      final resto = soma % 11;
      return resto < 2 ? 0 : 11 - resto;
    }

    final primeiro = digito(digitos.substring(0, 12));
    final segundo = digito('${digitos.substring(0, 12)}$primeiro');
    return digitos.substring(12) == '$primeiro$segundo';
  }
}
