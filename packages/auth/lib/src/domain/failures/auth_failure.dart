import 'package:equatable/equatable.dart';

export 'email/disabled_user_failure.dart';
export 'email/email_already_exists_failure.dart';
export 'email/invalid_email_failure.dart';
export 'email/wrong_authentication_method_failure.dart';
export 'other/invalid_credentials_failure.dart';
export 'other/invalid_verification_code.dart';
export 'other/missing_authentication_failure.dart';
export 'other/missing_permission_failure.dart';
export 'other/network_auth_failure.dart';
export 'other/unknown_auth_failure.dart';
export 'other/user_not_found_failure.dart';
export 'password/invalid_password_failure.dart';
export 'password/weak_password_failure.dart';
export 'password/wrong_password_failure.dart';

abstract class AuthFailure extends Equatable {
  final String code;

  const AuthFailure({required this.code});

  @override
  List<Object?> get props => [code];
}
