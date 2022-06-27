import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easel_flutter/datasources/database.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/services/third_party_services/audio_player_helper.dart';
import 'package:easel_flutter/services/third_party_services/network_info.dart';
import 'package:easel_flutter/env.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/services/third_party_services/video_player_helper.dart';
import 'package:easel_flutter/utils/file_utils_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
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
  sl.registerSingletonAsync<AppDatabase>(
          () => $FloorAppDatabase.databaseBuilder('app_database.db').build());


  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
  sl.registerFactory<VideoPlayerController>(() => VideoPlayerController.file(File('')));
  sl.registerFactory<AudioPlayer>(() => AudioPlayer());
}

void _registerRemoteDataSources() {
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(httpClient: sl<Dio>()));
}

void _registerLocalDataSources() {
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl(), sl()));
}

void _registerProviders() {
  sl.registerLazySingleton<EaselProvider>(() => EaselProvider(
        remoteDataSource: sl(),
        videoPlayerHelper: sl(),
        localDataSource: sl(),
        audioPlayerHelper: sl(),
        fileUtilsHelper: sl(),
      ));

  sl.registerLazySingleton<CreatorHubViewModel>(() => CreatorHubViewModel(sl(), sl()));
}

void _registerServices() {
  sl.registerFactory<FileUtilsHelper>(() => FileUtilsHelperImpl());
  sl.registerFactory<VideoPlayerHelper>(() => VideoPlayerHelperImp(sl()));
  sl.registerFactory<AudioPlayerHelper>(() => AudioPlayerHelperImpl(sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<Repository>(() => RepositoryImp(networkInfo: sl(), localDataSource: sl(), remoteDataSource: sl()));

}

