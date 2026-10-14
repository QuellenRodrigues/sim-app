import '../../core.dart';

extension DateExtensions on DateTime {
  /// Mesmo dia do calendário, ignorando o horário.
  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  /// Data sem horário.
  DateTime get dateOnly => DateTime(year, month, day);

  /// Ex.: "14/10".
  String get diaMes => DateFormat('dd/MM', 'pt_BR').format(this);

  /// Ex.: "terça-feira, 14 de outubro".
  String get extenso => DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(this);
}
