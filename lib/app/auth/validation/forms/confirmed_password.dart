import 'package:formz/formz.dart';
import 'package:homeapp/app/auth/validation/errors/confirm_password_validation_failures.dart';

import '../../../../core/classes/validation_failure.dart';

class ConfirmedPassword extends FormzInput<String, ValidationFailure> {
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmedPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  /// The original password.
  final String password;

  @override
  ValidationFailure? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return const AuthConfirmPasswordEmptyValidationFailure();
    }
    return password == value ? null : const AuthConfirmPasswordMatchFailure();
  }
}
