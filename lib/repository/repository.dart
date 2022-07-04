import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';

import 'package:easel_flutter/services/third_party_services/network_info.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/failure/failure.dart';
import 'package:easy_localization/easy_localization.dart';
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

  /// This method will generate the cookbook id for the easel app
  /// Output: [String] the id of the cookbook which will contains all the NFTs.
  Future<String> autoGenerateCookbookId();

  /// This method will save the username of the cookbook generator
  /// Input: [username] the username of the user who created the cookbook
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveCookBookGeneratorUsername(String username);

  /// This method will save the artist name
  /// Input: [name] the name of the artist which the user want to save
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveArtistName(String name);

  /// This method will get the artist name
  /// Output: [String] returns whether the operation is successful or not
  String getArtistName();

  /// This method will get the already created cookbook from the local database
  /// Output: [String] if the cookbook already exists return cookbook else return null
  String? getCookbookId();

  /// This method will get the username of the cookbook generator
  /// Output: [String] returns whether the operation is successful or not
  String getCookBookGeneratorUsername();

  /// This method will generate easel Id for the NFT
  /// Output: [String] the id of the NFT that is going to be added in the recipe
  String autoGenerateEaselId();

  /// This method will save the draft of the NFT
  /// Input: [NFT] the draft that will will be saved in database
  /// Output: [int] returns id of the inserted document
  /// will return error in the form of failure
  Future<Either<Failure, int>> saveNft(NFT draft);

  /// This method will update draft in the local database from description Page
  /// Input: [id] the id of the nft,
  /// [String] the  name of the nft , [String] the  description of the nft
  /// [String] the  creator name of the nft , [String] the page name of the Pageview
  /// Output: [bool] returns whether the operation is successful or not
  /// will return error in the form of failure
  Future<Either<Failure, bool>> updateNftFromDescription(int id, String nftName, String nftDescription, String creatorName, String step);

  /// This method will update draft in the local database from Pricing page
  /// Input: [id] the id of the nft, [String] the  name of the nft ,
  /// [String] the  tradePercentage of the nft , [String] the  price of the nft
  /// [String] the  quantity of the nft , [String] the page name of the Pageview
  /// Output: [bool] returns whether the operation is successful or not
  /// will return error in the form of failure
  Future<Either<Failure, bool>> updateNftFromPrice(int id, String tradePercentage, String price, String quantity, String step, String denomName, bool isFreeDrop);

  /// This method is used uploading provided file to the server using [httpClient]
  /// Input : [file] which needs to be uploaded
  /// Output : [ApiResponse] the ApiResponse which can contain [success] or [error] response
  Future<Either<Failure, ApiResponse>> uploadFile(File file);

  /// This method will get the drafts List from the local database
  /// Output: [List][NFT] returns  the List of drafts
  Future<Either<Failure, List<NFT>>> getNfts();

  /// This method will get the drafts List from the local database
  /// Output: [List][NFT] returns  the List of drafts
  Future<Either<Failure, NFT>> getNft(int id);

  /// This method will delete draft from the local database
  /// Input: [id] the id of the draft which the user wants to delete
  /// Output: [bool] returns whether the operation is successful or not
  Future<Either<Failure, bool>> deleteNft(int id);
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

  @override
  Future<String> autoGenerateCookbookId() async {
    return await localDataSource.autoGenerateCookbookId();
  }

  @override
  Future<bool> saveCookBookGeneratorUsername(String username) {
    return localDataSource.saveCookBookGeneratorUsername(username);
  }

  @override
  Future<bool> saveArtistName(String name) {
    return localDataSource.saveArtistName(name);
  }

  @override
  String getArtistName() {
    return localDataSource.getArtistName();
  }

  @override
  String? getCookbookId() {
    return localDataSource.getCookbookId();
  }

  @override
  String getCookBookGeneratorUsername() {
    return localDataSource.getCookBookGeneratorUsername();
  }

  @override
  String autoGenerateEaselId() {
    return localDataSource.autoGenerateEaselId();
  }

  @override
  Future<Either<Failure, int>> saveNft(NFT draft) async {
    try {
      int id = await localDataSource.saveNft(draft);
      return Right(id);
    } on Exception catch (_) {
      return Left(CacheFailure("save_error".tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNftFromDescription(int id, String nftName, String nftDescription, String creatorName, String step) async {
    try {
      bool result = await localDataSource.updateNftFromDescription(id, nftName, nftDescription, creatorName, step);

      if (!result) {
        return Left(CacheFailure("save_error".tr()));
      }
      return Right(result);
    } on Exception catch (_) {
      return Left(CacheFailure("save_error".tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNftFromPrice(int id, String tradePercentage, String price, String quantity, String step, String name, bool isFreeDrop) async {
    try {
      bool result = await localDataSource.updateNftFromPrice(id, tradePercentage, price, quantity, step, name, isFreeDrop);

      return Right(result);
    } on Exception catch (_) {
      return Left(CacheFailure("save_error".tr()));
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> uploadFile(File file) async {
    try {
      ApiResponse apiResponse = await remoteDataSource.uploadFile(file);

      return Right(apiResponse);
    } on Exception catch (_) {
      return Left(CacheFailure("update_failed".tr()));
    }
  }

  @override
  Future<Either<Failure, List<NFT>>> getNfts() async {
    try {
      final response = await localDataSource.getNfts();

      return Right(response);
    } on Exception catch (_) {
      return Left(CacheFailure("something_wrong".tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNft(int id) async {
    try {
      bool result = await localDataSource.deleteNft(id);
      return Right(result);
    } on Exception catch (_) {
      return Left(CacheFailure("something_wrong".tr()));
    }
  }

  @override
  Future<Either<Failure, NFT>> getNft(int id) async {
    try {
      NFT? data = await localDataSource.getNft(id);
      if (data == null) {
        return Left(CacheFailure("something_wrong".tr()));
      } else {
        return Right(data);
      }
    } on Exception catch (_) {
      return Left(CacheFailure("something_wrong".tr()));
    }
  }
}
