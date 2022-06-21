import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/env.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/services/third_party_services/video_player_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

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
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());

  log(apiKey); //your nft.storage api key
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
          baseUrl: "https://api.nft.storage",
          headers: {"Authorization": "Bearer $apiKey"},
          validateStatus: (statusCode) {
            return statusCode! <= HttpStatus.internalServerError;
          }),
    ),
  );

  sl.registerFactory<VideoPlayerController>(() => VideoPlayerController.file(File('')));
}

void _registerRemoteDataSources() {
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(httpClient: sl<Dio>()));
}

void _registerLocalDataSources() {
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sharedPreferences: sl()));
}

void _registerProviders() {
  sl.registerLazySingleton<EaselProvider>(() => EaselProvider(remoteDataSource: sl(), videoPlayerHelper: sl(), localDataSource: sl()));
  sl.registerLazySingleton<CreatorHubViewModel>(() => CreatorHubViewModel(localDataSource: sl(), remoteDataSource: sl()));
}

void _registerServices() {
  sl.registerFactory<VideoPlayerHelper>(() => VideoPlayerHelperImp(sl()));
}
