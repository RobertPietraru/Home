import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/auth/validation/forms/confirmed_password.dart';
import 'package:homeapp/core/failures/validation_failure.dart';
import 'package:homeapp/core/utils/translator.dart';

import '../../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/failures/app_failure.dart';
import '../../validation/forms/email.dart';
import '../../validation/forms/password.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  RegistrationCubit(
    this.authRepository, {
    required this.authBloc,
  }) : super(const RegistrationState(
          status: RegistrationStatus.init,
          confirmedPassword: ConfirmedPassword.dirty(password: ''),
          email: Email.dirty(),
          password: Password.dirty(),
        ));

  void onEmailChanged(String email) {
    final newEmail = Email.dirty(email);
    emit(state.copyWith(
      email: newEmail,
      status: RegistrationStatus.init,
      failure: null,
    ));
  }

  void onPasswordChanged(String password) {
    final newPassword = Password.dirty(password);
    emit(state.copyWith(
      password: newPassword,
      status: RegistrationStatus.init,
      failure: null,
    ));
  }

  void onConfirmedPasswordChanged(String confirmedPassword) {
    final newConfirmedPassword = ConfirmedPassword.dirty(
        password: state.password.value, value: confirmedPassword);
    emit(state.copyWith(
      confirmedPassword: newConfirmedPassword,
      status: RegistrationStatus.init,
      failure: null,
    ));
  }

  Future<void> register(BuildContext context) async {
    if (state.validationFailure != null) {
      emit(state.copyWith(
          status: RegistrationStatus.error,
          failure: AppFailure.fromAuthValidationFailure(
              state.validationFailure!, context.translator)));
      return;
    }

    emit(state.copyWith(status: RegistrationStatus.loading));
    final response = await authRepository.registerUser(
      RegisterParams(
        name: 'noname',
        email: state.email.value,
        password: state.password.value,
      ),
    );
    return response.fold((failure) {
      emit(state.copyWith(
        status: RegistrationStatus.error,
        failure: AppFailure.fromAuthFailure(failure, context.translator),
      ));
    }, (user) {
      emit(state.copyWith(
        status: RegistrationStatus.successful,
      ));
      authBloc.add(AuthUserLoggedIn(entity: user));
    });
  }
}
