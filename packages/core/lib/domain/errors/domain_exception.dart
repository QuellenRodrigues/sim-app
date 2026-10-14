import 'base_exception.dart';

///
/// Default Domain exception
///
class DomainException extends BaseException {
  DomainException({
    super.message = 'unexpectedError',
    super.label,
    super.exception,
  });

  @override
  List<Object?> get props => [label, message, exception];
}
