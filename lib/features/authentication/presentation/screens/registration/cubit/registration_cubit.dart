import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/features/authentication/presentation/validation/forms/confirmed_password.dart';
import '../../../../../../../packages/auth/lib/domain/failures/auth_failure.dart';
import '../../../../../../../packages/auth/lib/domain/usecases/register_usecase.dart';
import '../../../auth_bloc/auth_bloc.dart';
import '../../../validation/forms/email.dart';
import '../../../validation/forms/password.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegisterUsecase registerUsecase;
  final AuthBloc authBloc;

  RegistrationCubit(this.registerUsecase, {required this.authBloc})
      : super(const RegistrationState(
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

  Future<void> register() async {
    if (state.validationFailure != null) {
      emit(state.copyWith(status: RegistrationStatus.error));
      return;
    }
    emit(state.copyWith(status: RegistrationStatus.loading));
    final response = await registerUsecase.call(
      RegisterParams(
        name: 'noname',
        email: state.email.value,
        password: state.password.value,
      ),
    );
    return response.fold((failure) {
      emit(state.copyWith(
        status: RegistrationStatus.error,
        failure: failure,
      ));
    }, (user) {
      emit(state.copyWith(
        status: RegistrationStatus.successful,
      ));
      authBloc.add(AuthUserLoggedIn(entity: user));
    });
  }
}
