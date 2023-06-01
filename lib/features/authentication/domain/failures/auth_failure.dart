import 'package:flutter/material.dart';
import 'package:testador/core/utils/translator.dart';

import '../../../../core/classes/failure.dart';

enum FieldWithIssue { email, password, name, confirmedPassword, none }

abstract class AuthFailure extends Failure {
  const AuthFailure({required super.code, required this.fieldWithIssue});
  @override
  List<Object?> get props => [code, fieldWithIssue];

  final FieldWithIssue fieldWithIssue;

  /// Returns the error message translated to the current language
  String retrieveMessage(BuildContext context);
}

class AuthValidationFailure extends AuthFailure {
  const AuthValidationFailure(
      {required super.code, super.fieldWithIssue = FieldWithIssue.none});

  @override
  String retrieveMessage(BuildContext context) {
    throw UnimplementedError();
  }
}

class AuthDatabaseFailure extends AuthFailure {
  const AuthDatabaseFailure(
      {required super.code, super.fieldWithIssue = FieldWithIssue.none});

  @override
  String retrieveMessage(BuildContext context) {
    throw UnimplementedError();
  }
}

class AuthAuthorizationFailure extends AuthFailure {
  const AuthAuthorizationFailure(
      {required super.code, super.fieldWithIssue = FieldWithIssue.none});

  @override
  String retrieveMessage(BuildContext context) {
    throw UnimplementedError();
  }
}

class AuthNetworkFailure extends AuthFailure {
  const AuthNetworkFailure(
      {super.code = 'network-request-failed',
      super.fieldWithIssue = FieldWithIssue.none});

  @override
  String retrieveMessage(BuildContext context) {
    return context.translator.youAreNotConnected;
  }
}

abstract class AuthInputBackendFailure extends AuthFailure {
  const AuthInputBackendFailure({
    required super.code,
    super.fieldWithIssue = FieldWithIssue.none,
  });
}

class AuthUserNotFound extends AuthInputBackendFailure {
  const AuthUserNotFound({
    super.code = 'user-not-found',
    super.fieldWithIssue = FieldWithIssue.email,
  });

  @override
  String retrieveMessage(BuildContext context) {
    return context.translator.emailNotFound;
  }
}

class AuthWrongPassword extends AuthInputBackendFailure {
  const AuthWrongPassword({
    super.code = 'wrong-password',
    super.fieldWithIssue = FieldWithIssue.password,
  });

  @override
  String retrieveMessage(BuildContext context) {
    return context.translator.wrongPassword;
  }
}

class AuthUnknownFailure extends AuthFailure {
  const AuthUnknownFailure(
      {super.code = 'unknown', super.fieldWithIssue = FieldWithIssue.none});

  @override
  String retrieveMessage(BuildContext context) {
    return '${context.translator.thereWasAnError} unknown';
  }
}

class NoAuthFailure extends AuthFailure {
  const NoAuthFailure(
      {super.code = "no-auth-failure",
      super.fieldWithIssue = FieldWithIssue.none});

  @override
  String retrieveMessage(BuildContext context) {
    throw UnimplementedError();
  }
}
