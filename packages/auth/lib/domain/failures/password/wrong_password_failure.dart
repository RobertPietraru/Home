import 'package:auth/domain/failures/auth_failure.dart';

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure({required super.code});
}
