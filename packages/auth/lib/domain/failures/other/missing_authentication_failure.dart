import 'package:auth/domain/failures/auth_failure.dart';

class MissingAuthenticationFailure extends AuthFailure {
  const MissingAuthenticationFailure({super.code = 'authentication'});
}
