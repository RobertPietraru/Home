import 'package:auth/src/domain/failures/auth_failure.dart';

class InvalidPasswordFailure extends AuthFailure {
  const InvalidPasswordFailure({super.code = 'invalid-password'});
}
