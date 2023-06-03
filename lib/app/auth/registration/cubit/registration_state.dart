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
  final AppFailure? failure;

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
    return (failure?.fieldWithIssue == AuthFieldWithIssue.email
        ? failure?.message
        : null);
  }

  String? passwordFailure(BuildContext context) {
    if (status == RegistrationStatus.init) return null;
    return (failure?.fieldWithIssue == AuthFieldWithIssue.password
        ? failure?.message
        : null);
  }

  String? confirmPasswordFailure(BuildContext context) {
    if (status == RegistrationStatus.init) return null;
    return (failure?.fieldWithIssue == AuthFieldWithIssue.confirmedPassword
        ? failure?.message
        : null);
  }

  ValidationFailure? get validationFailure {
    return email.error ?? password.error ?? confirmedPassword.error;
  }

  RegistrationState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    RegistrationStatus? status,
    AppFailure? failure = AppFailure.mock,
  }) =>
      RegistrationState(
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        failure: failure == AppFailure.mock ? this.failure : failure,
      );
}
