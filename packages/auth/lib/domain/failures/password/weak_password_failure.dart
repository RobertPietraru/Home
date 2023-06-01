import 'package:auth/domain/failures/auth_failure.dart';

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure({required super.code});
}
