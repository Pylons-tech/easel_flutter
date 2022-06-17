import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/services/third_party_services/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env.dart';

final sl = GetIt.instance;

void init() {
  _registerProviders();
  _registerLocalDataSources();
  _registerRemoteDataSources();
  _registerServices();
  _registerRepository();
  _registerExternalDependencies();
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

  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
}

void _registerRemoteDataSources() {
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(sl<Dio>()));
}

void _registerLocalDataSources() {
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));
}

void _registerProviders() {
  sl.registerLazySingleton<EaselProvider>(() => EaselProvider(sl(), sl()));
  sl.registerLazySingleton<CreatorHubViewModel>(() => CreatorHubViewModel(sl(), sl(), sl()));
}

void _registerServices() {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

void _registerRepository() {
  sl.registerLazySingleton<Repository>(() => RepositoryImp(networkInfo: sl(), localDataSource: sl(), remoteDataSource: sl()));
}
