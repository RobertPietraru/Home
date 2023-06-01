import '../../../../core/classes/validation_failure.dart';

class AuthEmailEmptyValidationFailure extends ValidationFailure {
  const AuthEmailEmptyValidationFailure({super.code = 'empty-email'});
}

class AuthEmailInvalidFailure extends ValidationFailure {
  const AuthEmailInvalidFailure({super.code = 'invalid-email'});
}
