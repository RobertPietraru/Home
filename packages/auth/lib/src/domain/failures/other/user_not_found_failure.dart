import 'package:auth/src/domain/failures/auth_failure.dart';

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure({ super.code = 'user-not-found'});
}