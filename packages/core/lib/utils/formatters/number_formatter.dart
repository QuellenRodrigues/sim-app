import '../../core.dart';

/// Formatação numérica no padrão brasileiro.
abstract final class NumberFormatter {
  static final _inteiro = NumberFormat.decimalPattern('pt_BR');
  static final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
  static final _decimal = NumberFormat('0.##', 'pt_BR');

  /// Ex.: 1250 → "1.250".
  static String inteiro(num valor) => _inteiro.format(valor);

  /// Ex.: 12480 → "R$ 12.480,00".
  static String moeda(num valor) => _moeda.format(valor);

  /// Ex.: 0.87 → "87%".
  static String percentual(double fracao) => '${(fracao * 100).round()}%';

  /// Número para um campo editável, sem separador de milhar. Ex.: 2.5 → "2,5"; 5.0 → "5".
  static String decimal(num valor) => _decimal.format(valor);

  /// Lê o que foi digitado em um campo numérico; `null` se não for um número. Ex.: "2,5" → 2.5.
  static double? lerDecimal(String texto) => double.tryParse(texto.trim().replaceAll(',', '.'));
}
