import 'package:auth/domain/failures/auth_failure.dart';

class InvalidVerificationCodeFailure extends AuthFailure {
  const InvalidVerificationCodeFailure({required super.code});
}
