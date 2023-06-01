import 'package:auth/domain/failures/auth_failure.dart';

class WrongAuthenticationMethodFailure extends AuthFailure {
  const WrongAuthenticationMethodFailure({required super.code});
}