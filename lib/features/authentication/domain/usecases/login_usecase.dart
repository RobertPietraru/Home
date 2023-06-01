import 'package:dartz/dartz.dart';

import '../../../../core/classes/usecase.dart';
import '../auth_domain.dart';
import '../failures/auth_failure.dart';

class LoginUsecase extends UseCase<UserEntity, LoginParams> {
  const LoginUsecase(this.authRepository);
  final AuthRepository authRepository;

  @override
  Future<Either<AuthFailure, UserEntity>> call(params) async {
    return authRepository.loginUser(params);
  }
}

class LoginParams extends Params {
  const LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}
