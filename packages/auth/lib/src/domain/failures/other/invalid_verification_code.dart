import 'package:auth/src/domain/failures/auth_failure.dart';

class InvalidVerificationCodeFailure extends AuthFailure {
  const InvalidVerificationCodeFailure({required super.code});
}
