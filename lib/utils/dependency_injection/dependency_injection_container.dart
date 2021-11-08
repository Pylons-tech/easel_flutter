import 'package:dio/dio.dart';
import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

void init() {
  _registerProviders();
  _registerLocalDataSources();
  _registerRemoteDataSources();
  _registerExternalDependencies();
}

void _registerExternalDependencies() {
  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());

  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(baseUrl: "https://api.nft.storage", headers: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweGQ1QmMxZjZDODZEYzFEMmQ2OGI4NDU3YzUyMzM1NTIzM0M5MGYxQjgiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTYzNjM3ODEzNDE5MywibmFtZSI6IkVhc2VsX3Rlc3QifQ.J40jE3szRBsuENob-ZNBunQ6ITIcYspzOne6A8MyN7c"
      }),
    ),
  );
}

void _registerRemoteDataSources() {
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(sl<Dio>()));
}

void _registerLocalDataSources() {
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));
}

void _registerProviders() {
  sl.registerLazySingleton<EaselProvider>(() => EaselProvider(sl(), sl()));
}
