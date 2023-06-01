import 'package:dartz/dartz.dart';

import '../auth_domain.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, UserEntity>> registerUser(RegisterParams params);
  Future<Either<AuthFailure, UserEntity>> logUserIn(LoginParams params);
  Future<Either<AuthFailure, UserEntity>> getUserById(String id);
  Future<Either<AuthFailure, void>> logUserOut();
  Future<Either<AuthFailure, UserEntity?>> getLocalUser();
}

class RegisterParams {
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });
  final String email;
  final String password;
  final String name;
}

class LoginParams {
  const LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}
