import 'package:dartz/dartz.dart';

import '../../../../core/classes/usecase.dart';
import '../auth_domain.dart';
import '../failures/auth_failure.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, UserEntity>> registerUser(RegisterParams params);
  Future<Either<AuthFailure, UserEntity>> loginUser(LoginParams params);
  Future<Either<AuthFailure, UserEntity>> getUserById(String id);
  Future<Either<AuthFailure, void>> logUserOut();
  Future<Either<AuthFailure, UserEntity?>> getLocalUser();
}
