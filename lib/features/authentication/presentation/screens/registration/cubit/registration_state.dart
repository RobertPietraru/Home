part of 'registration_cubit.dart';

enum RegistrationStatus { error, loading, successful, init }

class RegistrationState extends Equatable {
  const RegistrationState({
    required this.confirmedPassword,
    required this.email,
    required this.password,
    this.failure,
    this.status = RegistrationStatus.init,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final RegistrationStatus status;
  final AuthFailure? failure;

  @override
  List<Object?> get props =>
      [email, password, status, failure, confirmedPassword, validationFailure];

  bool get isLoading {
    return status == RegistrationStatus.loading;
  }

  bool get isSuccessful {
    return status == RegistrationStatus.successful;
  }

  String? emailFailure(BuildContext context) {
    if (status == RegistrationStatus.init) return null;
    return email.error?.retrieveMessage(context) ??
        (failure?.fieldWithIssue == FieldWithIssue.email
            ? failure?.retrieveMessage(context)
            : null);
  }

  String? passwordFailure(BuildContext context) {
    if (status == RegistrationStatus.init) return null;
    return password.error?.retrieveMessage(context) ??
        (failure?.fieldWithIssue == FieldWithIssue.password
            ? failure?.retrieveMessage(context)
            : null);
  }

  String? confirmPasswordFailure(BuildContext context) {
    if (status == RegistrationStatus.init) return null;
    return confirmedPassword.error?.retrieveMessage(context) ??
        (failure?.fieldWithIssue == FieldWithIssue.confirmedPassword
            ? failure?.retrieveMessage(context)
            : null);
  }

  AuthFailure? get validationFailure {
    return email.error ?? password.error ?? confirmedPassword.error;
  }

  RegistrationState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    RegistrationStatus? status,
    AuthFailure? failure = const NoAuthFailure(),
  }) =>
      RegistrationState(
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        failure: failure == const NoAuthFailure() ? this.failure : failure,
      );
}
