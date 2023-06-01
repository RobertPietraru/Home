import 'package:flutter/material.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:homeapp/features/authentication/domain/failures/auth_failure.dart';

class AuthPasswordEmptyValidationFailure extends AuthValidationFailure {
  AuthPasswordEmptyValidationFailure({super.code = 'empty-password'});

  @override
  String retrieveMessage(BuildContext context) =>
      context.translator.youMustProvideAPassword;
}

class AuthPasswordInvalidFailure extends AuthValidationFailure {
  AuthPasswordInvalidFailure({super.code = 'invalid-password'});

  @override
  String retrieveMessage(BuildContext context) =>
      context.translator.passwordToWeak;
}
