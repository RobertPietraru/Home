import 'package:equatable/equatable.dart';

import 'package:formz/formz.dart';
import 'package:homeapp/app/auth/validation/errors/email_validation_failures.dart';

import '../../../../core/failures/validation_failure.dart';

class Email extends FormzInput<String, ValidationFailure>
    with EquatableMixin {
  const Email.pure() : super.pure('');

  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  ValidationFailure? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return const AuthEmailEmptyValidationFailure();
    }

    return _emailRegExp.hasMatch(value ?? '')
        ? null
        : const AuthEmailInvalidFailure();
  }

  @override
  List<Object?> get props => [value, isValid, error];
}
