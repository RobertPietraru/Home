import 'package:get_it/get_it.dart';

import '../household.dart';
import 'data/datasource/home_remote_data_source.dart';
import 'data/repositories/home_repository_impl.dart';

void householdInject() {
  final locator = GetIt.instance;
  locator
    ..registerSingleton<HomeRemoteDataSource>(HomeFirebaseDataSourceIMPL())
    ..registerSingleton<HomeRepository>(HomeRepositoryIMPL(locator()));
}
