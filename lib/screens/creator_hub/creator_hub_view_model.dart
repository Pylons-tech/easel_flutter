import 'dart:developer';

import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/widgets/loading.dart';
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

  bool _publishCollapse = true;

  bool get publishCollapse => _publishCollapse;

  set publishCollapse(bool value) {
    _publishCollapse = value;
    notifyListeners();
  }

  bool _draftCollapse = true;

  bool get draftCollapse => _draftCollapse;

  set draftCollapse(bool value) {
    _draftCollapse = value;
    notifyListeners();
  }

  final List<NFT> _publishedNFTsList = [];

  List<NFT> get publishedNFTsList => _publishedNFTsList;

  String? getCookbookIdFromLocalDatasource() {
    return localDataSource.getCookbookId();
  }

  void getRecipesList() async {
    final loading = Loading().showLoading(message: kPleaseWait);

    final cookBookId = getCookbookIdFromLocalDatasource();
    if (cookBookId == null) {
      loading.dismiss();
      return;
    }

    final recipesListEither = await repository.getRecipesBasedOnCookBookId(cookBookId: cookBookId);

    if (recipesListEither.isLeft()) {
      loading.dismiss();
      return;
    }

    final recipesList = recipesListEither.getOrElse(() => []);
    _publishedNFTsList.clear();
    if (recipesList.isNotEmpty) {
      for (final recipe in recipesList) {
        final nft = NFT.fromRecipe(recipe);
        _publishedNFTsList.add(nft);
      }
    }

    publishedRecipeLength = publishedNFTsList.length;
    loading.dismiss();

    log('recipesLength: $publishedRecipesLength');
  }
}
