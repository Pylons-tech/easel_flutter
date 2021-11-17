import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/env.dart';
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

  log(apiKey);
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(baseUrl: "https://api.nft.storage", headers: {
        "Authorization":
            "Bearer $apiKey"
      },
        validateStatus: (statusCode){
          return statusCode! <= HttpStatus.internalServerError;
        }
      ),
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
