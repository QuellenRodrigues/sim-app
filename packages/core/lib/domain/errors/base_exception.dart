import 'package:flutter/foundation.dart';

import '../../../core.dart';

///
/// Base class for exceptions
///
abstract class BaseException extends Equatable implements Exception {
  /// Internal default error message
  final String message;

  /// Optional original name function
  final String? label;

  /// Optional custom data
  final dynamic exception;

  /// Stack trace
  final StackTrace? stackTrace;

  BaseException({
    required this.message,
    this.label,
    this.exception,
    this.stackTrace,
  }) {
    if (stackTrace != null) {
      debugPrintStack(label: label, stackTrace: stackTrace);
    }
  }
  @override
  List<Object?> get props => [message, label, exception];
}
