import 'package:get_it/get_it.dart';

import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';

void authInject() {
  final locator = GetIt.instance;
  locator
    ..registerSingleton<AuthRemoteDataSource>(AuthFirebaseDataSourceIMPL())
    ..registerSingleton<AuthRepository>(AuthRepositoryIMPL(locator()));
}
