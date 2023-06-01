import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const AuthUninitialisedState()) {
    on<AuthCheckedAuthentication>((event, emit) => checkAuthentication(emit));
    on<AuthUserLoggedIn>((event, emit) {
      emit(AuthAuthenticatedState(event.entity));
    });
    on<AuthUserLoggedOut>((event, emit) => logUserOut(emit));
    add(AuthCheckedAuthentication());
  }

  Future<void> logUserOut(Emitter<AuthState> emit) async {
    final response = await authRepository.logUserOut();
    return response.fold((l) {
      emit(AuthFailureState(failure: l));
    }, (r) {
      emit(const AuthUnauthenticatedState());
    });
  }

  Future<void> checkAuthentication(Emitter<AuthState> emit) async {
    final response = await authRepository.getLocalUser();
    return response.fold((l) {
      emit(const AuthUnauthenticatedState());
    }, (r) {
      if (r == null) {
        emit(const AuthUnauthenticatedState());
        return;
      }
      emit(AuthAuthenticatedState(r));
    });
  }
}
