import 'dart:developer';

import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

class CreatorHubViewModel extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  Repository repository;

  CreatorHubViewModel(this.localDataSource, this.remoteDataSource, this.repository);

  int _publishedRecipesLength = 0;

  get publishedRecipesLength => _publishedRecipesLength;

  set publishedRecipeLength(int value) {
    _publishedRecipesLength = value;

    notifyListeners();
  }

  final List<Recipe> _publishedRecipesList = [];

  List<Recipe> get publishedRecipesList => _publishedRecipesList;

  String? getCookbookIdFromLocalDatasource() {
    return localDataSource.getCookbookId();
  }

  getRecipesList() async {
    final cookBookId = getCookbookIdFromLocalDatasource();
    if (cookBookId == null) return;

    final recipesListEither = await repository.getRecipesBasedOnCookBookId(cookBookId: cookBookId);

    if (recipesListEither.isLeft()) {
      return;
    }

    final recipesList = recipesListEither.toOption();

    publishedRecipesList.addAll(recipesList as List<Recipe>);

    log('recipesLength: ${publishedRecipesList.length}');
  }
}
