import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';

import 'package:easel_flutter/services/third_party_services/network_info.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/failure/failure.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

abstract class Repository {
  /// This method returns the recipe list
  /// Input : [cookBookId] id of the cookbook
  /// Output: if successful the output will be the list of [pylons.Recipe]
  /// will return error in the form of failure
  Future<Either<Failure, List<Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId});

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  String getCacheString({required String key});

  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [value] will return the value that is just removed
  String deleteCacheString({required String key});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  void setCacheString({required String key, required String value});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  bool setCacheDynamicType({required String key, required dynamic value});

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  dynamic getCacheDynamicType({required String key});

  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [value] will return the value that is just removed
  dynamic deleteCacheDynamic({required String key});
}

class RepositoryImp implements Repository {
  final NetworkInfo networkInfo;
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  RepositoryImp({required this.networkInfo, required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(kNoInternet));
    }

    try {
      var sdkResponse = await remoteDataSource.getRecipesByCookbookID(cookBookId);
      log(sdkResponse.toString(), name: 'pylons_sdk');

      return Right(sdkResponse);
    } on Exception catch (_) {
      return const Left(CookBookNotFoundFailure(kCookBookNotFound));
    }
  }

  @override
  dynamic deleteCacheDynamic({required String key}) {
    localDataSource.deleteCacheDynamic(key: key);
  }

  @override
  String deleteCacheString({required String key}) {
    return localDataSource.deleteCacheString(key: key);
  }

  @override
  dynamic getCacheDynamicType({required String key}) {
    return localDataSource.getCacheDynamicType(key: key);
  }

  @override
  String getCacheString({required String key}) {
    return localDataSource.getCacheString(key: key);
  }

  @override
  bool setCacheDynamicType({required String key, required value}) {
    return localDataSource.setCacheDynamicType(key: key, value: value);
  }

  @override
  void setCacheString({required String key, required String value}) {
    localDataSource.setCacheString(key: key, value: value);
  }
}
