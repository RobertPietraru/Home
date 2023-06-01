import 'package:equatable/equatable.dart';

import 'package:formz/formz.dart';
import 'package:testador/features/authentication/domain/failures/auth_failure.dart';
import 'package:testador/features/authentication/presentation/validation/errors/email_validation_failures.dart';

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class Email extends FormzInput<String, AuthValidationFailure>
    with EquatableMixin {
  /// {@macro email}
  const Email.pure() : super.pure('');

  /// {@macro email}
  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  AuthValidationFailure? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return AuthEmailEmptyValidationFailure();
    }

    return _emailRegExp.hasMatch(value ?? '')
        ? null
        : AuthEmailInvalidFailure();
  }

  @override
  List<Object?> get props => [value, isValid, error];
}
