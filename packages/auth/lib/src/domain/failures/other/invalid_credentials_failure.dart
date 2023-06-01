import 'package:auth/src/domain/failures/auth_failure.dart';

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({required super.code});
}
