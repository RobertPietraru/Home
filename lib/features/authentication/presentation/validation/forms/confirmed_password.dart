import 'package:formz/formz.dart';
import 'package:homeapp/features/authentication/domain/failures/auth_failure.dart';
import 'package:homeapp/features/authentication/presentation/validation/errors/confirm_password_validation_failures.dart';

class ConfirmedPassword extends FormzInput<String, AuthValidationFailure> {
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmedPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  /// The original password.
  final String password;

  @override
  AuthValidationFailure? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return AuthConfirmPasswordEmptyValidationFailure();
    }
    return password == value ? null : AuthConfirmPasswordMatchFailure();
  }
}
