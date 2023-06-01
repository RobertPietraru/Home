import 'package:homeapp/core/classes/validation_failure.dart';

class AuthConfirmPasswordEmptyValidationFailure extends ValidationFailure {
  const AuthConfirmPasswordEmptyValidationFailure(
      {super.code = 'empty-confirm-password'});
}

class AuthConfirmPasswordMatchFailure extends ValidationFailure {
  const AuthConfirmPasswordMatchFailure(
      {super.code = 'invalid-confirm-Password'});
}
