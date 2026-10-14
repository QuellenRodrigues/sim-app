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
}
