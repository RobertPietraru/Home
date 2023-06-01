import 'package:auth/domain/failures/auth_failure.dart';

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure({ super.code = 'user-not-found'});
}