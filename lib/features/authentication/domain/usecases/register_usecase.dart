import 'package:dartz/dartz.dart';

import '../../../../core/classes/usecase.dart';
import '../auth_domain.dart';
import '../failures/auth_failure.dart';

class RegisterUsecase extends UseCase<UserEntity, RegisterParams> {
  const RegisterUsecase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<Either<AuthFailure, UserEntity>> call(params) async {
    return authRepository.registerUser(params);
  }
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
