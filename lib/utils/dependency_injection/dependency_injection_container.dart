import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

void init() {
  _registerProviders();
  _registerLocalDataSources();
  _registerExternalDependencies();
}

void _registerExternalDependencies() {
  sl.registerLazySingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());
}

void _registerLocalDataSources() {
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));
}

void _registerProviders() {
  sl.registerLazySingleton<EaselProvider>(() => EaselProvider(sl()));
}
