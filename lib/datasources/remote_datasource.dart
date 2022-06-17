import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/storage_response_model.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

abstract class RemoteDataSource {
  Future<ApiResponse<StorageResponseModel>> uploadFile(File file);

  Future<List<Recipe>> getRecipesByCookbookID(String cookBookID);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio httpClient;

  RemoteDataSourceImpl(this.httpClient);

  @override
  Future<ApiResponse<StorageResponseModel>> uploadFile(File file) {
    return httpClient
        .post(
      "/upload",
      data: Stream.fromIterable(file.readAsBytesSync().map((e) => [e])),
      options: Options(headers: {
        'Content-Length': file.lengthSync().toString(),
      }),
    )
        .then((response) {
      if (response.statusCode == HttpStatus.ok) {
        final data = StorageResponseModel.fromJson(response.data);
        return ApiResponse<StorageResponseModel>.success(data: data);
      }

      return ApiResponse<StorageResponseModel>.error(errorMessage: response.data["error"]["message"] ?? "Upload Failed");
    }).catchError((error) => ApiResponse<StorageResponseModel>.error(errorMessage: error.toString()));
  }

  @override
  Future<List<Recipe>> getRecipesByCookbookID(String cookBookID) async {
    var sdkResponse = await PylonsWallet.instance.getRecipes(cookBookID);
    return sdkResponse.data;
  }
}
