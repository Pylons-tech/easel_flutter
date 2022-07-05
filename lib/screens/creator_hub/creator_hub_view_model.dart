import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class CreatorHubViewModel extends ChangeNotifier {
  final Repository repository;

  CreatorHubViewModel(this.repository);

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
    return repository.getCookbookId();
  }

  Future<void> getPublishAndDraftData() async{
    await getDraftsList();
   await getRecipesList();
   notifyListeners();

  }

  Future<void> getRecipesList() async {
    final loading = Loading().showLoading(message: "loading ...");

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
  }




  List<NFT> nftList = [];

  Future<void> getDraftsList() async {
    final loading = Loading().showLoading(message: "Uploading ...");

    final getNftResponse = await repository.getNfts();

    if (getNftResponse.isLeft()) {
      loading.dismiss();

      navigatorKey.currentState!.overlay!.context.show(message: "something_wrong".tr());

      return;
    }

    nftList = getNftResponse.getOrElse(() => []);

    loading.dismiss();

    notifyListeners();
  }

  Future<void> deleteNft(int? id) async {
    final deleteNftResponse = await repository.deleteNft(id!);

    if (deleteNftResponse.isLeft()) {
      navigatorKey.currentState!.overlay!.context.show(message: "delete_error".tr());
    }
    else{
      nftList.removeWhere((element) => element.id == id);
      notifyListeners();

    }
  }
}