part of 'login_cubit.dart';

enum LoginStatus { error, loading, successful, init }

class LoginState extends Equatable {
  const LoginState({
    required this.email,
    required this.password,
    this.failure,
    this.status = LoginStatus.init,
  });

  final Email email;
  final Password password;
  final LoginStatus status;
  final AuthFailure? failure;

  @override
  List<Object?> get props => [email, password, status, failure];

  bool get isLoading {
    return status == LoginStatus.loading;
  }

  bool get isSuccessful {
    return status == LoginStatus.successful;
  }

  bool get isValid {
    return validationFailure == null;
  }

  String? emailFailure(BuildContext context) {
    return failure?.fieldWithIssue == FieldWithIssue.email
        ? failure?.retrieveMessage(context)
        : null;
  }

  String? passwordFailure(BuildContext context) {
    return failure?.fieldWithIssue == FieldWithIssue.password
        ? failure?.retrieveMessage(context)
        : null;
  }

  bool get isInvalid {
    return !isValid;
  }

  AuthFailure? get validationFailure {
    final emailValidationError = email.error;
    final passwordValidationError = password.error;
    return emailValidationError ?? passwordValidationError;
  }

  LoginState copyWith({
    Email? email,
    Password? password,
    LoginStatus? status,
    AuthFailure? failure = const NoAuthFailure(),
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        failure: failure == const NoAuthFailure() ? this.failure : failure,
      );
}
