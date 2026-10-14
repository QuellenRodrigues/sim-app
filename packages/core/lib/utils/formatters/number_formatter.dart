import '../../core.dart';

/// Formatação numérica no padrão brasileiro.
abstract final class NumberFormatter {
  static final _inteiro = NumberFormat.decimalPattern('pt_BR');
  static final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');

  /// Ex.: 1250 → "1.250".
  static String inteiro(num valor) => _inteiro.format(valor);

  /// Ex.: 12480 → "R$ 12.480,00".
  static String moeda(num valor) => _moeda.format(valor);

  /// Ex.: 0.87 → "87%".
  static String percentual(double fracao) => '${(fracao * 100).round()}%';
}
