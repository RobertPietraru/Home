part of 'auth_bloc.dart';

enum AuthFieldWithIssue {
  email,
  password,
  confirmedPassword,
  name,
  other,
  none
}

abstract class AuthState extends Equatable {
  const AuthState();

  UserEntity? get userEntity {
    final state = this;
    if (state is AuthAuthenticatedState) {
      return state.entity;
    }
    return null;
  }
}

class AuthUninitialisedState extends AuthState {
  const AuthUninitialisedState();
  @override
  List<Object?> get props => ['init'];
}

class AuthAuthenticatedState extends AuthState {
  const AuthAuthenticatedState(this.entity);

  final UserEntity entity;

  @override
  List<Object?> get props => [entity];
}

class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
  @override
  List<Object?> get props => ['logged_out'];
}

class AuthFailureState extends AuthState {
  final AuthFailure failure;
  const AuthFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}
