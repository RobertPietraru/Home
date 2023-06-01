import 'package:flutter/material.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:homeapp/features/authentication/domain/failures/auth_failure.dart';

class AuthConfirmPasswordEmptyValidationFailure extends AuthValidationFailure {
  AuthConfirmPasswordEmptyValidationFailure(
      {super.code = 'empty-confirm-Password'});

  @override
  String retrieveMessage(BuildContext context) =>
      context.translator.youMustConfirmThePassword;
}

class AuthConfirmPasswordMatchFailure extends AuthValidationFailure {
  AuthConfirmPasswordMatchFailure({super.code = 'invalid-confirm-Password'});

  @override
  String retrieveMessage(BuildContext context) =>
      context.translator.passwordsDontMatch;
}
