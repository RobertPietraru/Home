import '../../injection.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/get_local_user_usecase.dart';
import 'domain/usecases/get_user_by_id_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/register_usecase.dart';


void authInject() {
  locator
    ..registerSingleton<AuthRemoteDataSource>(AuthFirebaseDataSourceIMPL())
    ..registerSingleton<AuthRepository>(AuthRepositoryIMPL(locator()))
    ..registerSingleton<GetLocalUserUsecase>(GetLocalUserUsecase(locator()))
    ..registerSingleton(LoginUsecase(locator()))
    ..registerSingleton(LogoutUsecase(locator()))
    ..registerSingleton(RegisterUsecase(locator()))
    ..registerSingleton(GetUserByIdUsecase(locator()));
}
