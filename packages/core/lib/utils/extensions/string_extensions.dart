import '../../core.dart';

extension StringExtensions on String {
  /// Converte o primeiro caractere para maiúsculo.
  /// Com [allWords], capitaliza cada palavra.
  String toCapitalized({bool allWords = false}) {
    if (isEmpty) return '';
    if (allWords) {
      return split(' ').map((str) => toBeginningOfSentenceCase(str.toLowerCase())).join(' ');
    }
    return toBeginningOfSentenceCase(toLowerCase());
  }

  /// Só os dígitos do texto (ex.: "11.222.333/0001-81" → "11222333000181").
  String get somenteDigitos => replaceAll(RegExp(r'\D'), '');

  /// Minúsculas e sem acentos, para buscas ("Metalúrgica" → "metalurgica").
  String get normalizado {
    const de = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const para = 'aaaaaeeeeiiiiooooouuuucn';
    final minusculo = toLowerCase();
    final buffer = StringBuffer();
    for (final rune in minusculo.runes) {
      final caractere = String.fromCharCode(rune);
      final indice = de.indexOf(caractere);
      buffer.write(indice >= 0 ? para[indice] : caractere);
    }
    return buffer.toString();
  }
}
