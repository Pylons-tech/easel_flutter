import 'dart:developer';

import 'package:dartz/dartz.dart';
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

  /// This method will save the draft of the NFT
  /// Input: [NFT] the draft that will be saved in database
  /// Output: [bool] returns whether the operation is successful or not
  /// will return error in the form of failure
  Future<Either<Failure, bool>> saveNft(NFT draft);
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
  Future<Either<Failure, bool>> saveNft(NFT draft) async {
    try {
      await localDataSource.saveNft(draft);
      return const Right(true);
    } on Exception catch (_) {
      return Left(CacheFailure("save_error".tr()));
    }
  }
}
