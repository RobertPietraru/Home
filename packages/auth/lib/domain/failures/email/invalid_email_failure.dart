import 'package:auth/domain/failures/auth_failure.dart';

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure({required super.code});
}