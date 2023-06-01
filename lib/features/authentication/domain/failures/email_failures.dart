import 'package:flutter/material.dart';
import 'package:homeapp/features/authentication/domain/failures/auth_failure.dart';

class AuthEmailAlreadyExistsFailure extends AuthInputBackendFailure {
  const AuthEmailAlreadyExistsFailure(
      {super.code = 'email-already-exists',
      super.fieldWithIssue = FieldWithIssue.email});

  @override
  String retrieveMessage(BuildContext context) {
    return "Email-ul este deja folosit";
  }
}
