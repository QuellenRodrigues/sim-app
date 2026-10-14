import 'package:flutter/foundation.dart';

import '../../core.dart';

///
/// App logging
///
abstract class Log {
  static final _logger = Logger(printer: kIsWeb ? PrettyPrinter(colors: false) : null);

  /// Trace level
  static void t(Object? message, [dynamic data]) {
    if (kDebugMode) _logger.t(message, error: data);
  }

  /// Info level
  static void i(Object? message, [dynamic data]) {
    if (kDebugMode) _logger.i(message, error: data);
  }

  /// Debug level
  static void d(Object? message, [dynamic data]) {
    if (kDebugMode) _logger.d(message, error: data);
  }

  /// Warning level
  static void w(Object? message, [dynamic data]) {
    if (kDebugMode) _logger.w(message, error: data);
  }

  /// Error level
  static void e(Object? message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
