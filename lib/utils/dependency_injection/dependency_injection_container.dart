import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env.dart';

import '../../services/third_party_services/audio_player_helper.dart';

final sl = GetIt.instance;
void init() {
  _registerServices();
  _registerProviders();
  _registerLocalDataSources();
  _registerRemoteDataSources();
  _registerExternalDependencies();
}

void _registerExternalDependencies() {
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());

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

  sl.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
}

void _registerRemoteDataSources() {
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(sl<Dio>()));
}

void _registerLocalDataSources() {
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));
}

void _registerProviders() {
  sl.registerLazySingleton<EaselProvider>(() => EaselProvider(sl(), sl(), sl()));
}

void _registerServices() {
  sl.registerLazySingleton<AudioPlayerHelper>(() => AudioPlayerHelperImpl(sl()));
  sl.registerLazySingleton<EaselProvider>(() => EaselProvider(sl(), sl()));
  sl.registerLazySingleton<CreatorHubViewModel>(() => CreatorHubViewModel(sl(), sl()));

}
