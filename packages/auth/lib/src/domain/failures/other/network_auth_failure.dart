import 'package:auth/src/domain/failures/auth_failure.dart';

class NetworkAuthFailure extends AuthFailure {
  const NetworkAuthFailure({ super.code = 'network'});
}
