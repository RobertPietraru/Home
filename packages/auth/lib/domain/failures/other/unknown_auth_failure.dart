import 'package:auth/domain/failures/auth_failure.dart';

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure({ super.code = 'unknown'});
}
