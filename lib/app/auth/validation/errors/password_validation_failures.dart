import '../../../../core/classes/validation_failure.dart';

class AuthPasswordEmptyValidationFailure extends ValidationFailure {
  const AuthPasswordEmptyValidationFailure({super.code = 'empty-password'});
}

class AuthPasswordInvalidFailure extends ValidationFailure {
  const AuthPasswordInvalidFailure({super.code = 'invalid-password'});
}
