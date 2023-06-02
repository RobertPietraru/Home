part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthCheckedAuthentication extends AuthEvent {
  @override
  List<Object?> get props => ['checked'];
}

class AuthUserLoggedIn extends AuthEvent {
  const AuthUserLoggedIn({required this.entity});

  final UserEntity entity;
  @override
  List<Object?> get props => [entity];
}

class AuthUserLoggedOut extends AuthEvent {
  const AuthUserLoggedOut();

  @override
  List<Object?> get props => ['logged_out'];
}
