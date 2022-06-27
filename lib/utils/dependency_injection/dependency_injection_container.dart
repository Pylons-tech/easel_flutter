import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easel_flutter/datasources/database.dart';
import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env.dart';

final sl = GetIt.instance;
void init() {
  _registerProviders();
  _registerLocalDataSources();
  _registerRemoteDataSources();
  _registerExternalDependencies();
  _registerServices();
}

void _registerExternalDependencies() {
  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());

  log(apiKey); //your nft.storage api key
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

  sl.registerSingletonAsync<AppDatabase>(
          () => $FloorAppDatabase.databaseBuilder('app_database.db').build());

}

  sl.registerFactory<VideoPlayerController>(() => VideoPlayerController.file(File('')));
}
void _registerRemoteDataSources() {
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(sl<Dio>()));
}

void _registerLocalDataSources() {
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl(), sl()));
}

void _registerProviders() {
  sl.registerLazySingleton<EaselProvider>(() => EaselProvider(sl(), sl()));
  sl.registerLazySingleton<CreatorHubViewModel>(() => CreatorHubViewModel(sl(), sl()));

void _registerServices() {
  sl.registerFactory<VideoPlayerHelper>(() => VideoPlayerHelperImp(sl()));
}
