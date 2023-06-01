import 'package:auth/src/domain/failures/auth_failure.dart';

class MissingPermissionFailure extends AuthFailure {
  const MissingPermissionFailure({super.code = 'permission'});
}
