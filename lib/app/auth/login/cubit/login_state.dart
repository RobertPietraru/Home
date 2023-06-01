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
  final AppFailure<AuthFieldWithIssue>? failure;

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
    return failure?.fieldWithIssue == AuthFieldWithIssue.email
        ? failure?.message
        : null;
  }

  String? passwordFailure(BuildContext context) {
    return failure?.fieldWithIssue == AuthFieldWithIssue.password
        ? failure?.message
        : null;
  }

  bool get isInvalid {
    return !isValid;
  }

  ValidationFailure? get validationFailure {
    final emailValidationError = email.error;
    final passwordValidationError = password.error;
    return emailValidationError ?? passwordValidationError;
  }

  LoginState copyWith({
    Email? email,
    Password? password,
    LoginStatus? status,
    AppFailure<AuthFieldWithIssue>? failure =
        const AppFailure<AuthFieldWithIssue>(
      code: '',
      message: '',
    ),
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        failure: failure ==
                const AppFailure<AuthFieldWithIssue>(
                  code: '',
                  message: '',
                )
            ? this.failure
            : failure,
      );
}
