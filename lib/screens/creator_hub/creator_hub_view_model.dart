import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
enum ViewType{
  viewGrid, viewList
}

enum CollectionType{
  draft, published, forSale
}
class CreatorHubViewModel extends ChangeNotifier {
  final Repository repository;

  CreatorHubViewModel(this.repository);

  CollectionType selectedCollectionType = CollectionType.draft;
  List<NFT> nftdraftList = [];

  ViewType viewType =ViewType.viewList;

  int _publishedRecipesLength = 0;
  int forSaleCount = 0;

  get publishedRecipesLength => _publishedRecipesLength;

  set publishedRecipeLength(int value) {
    _publishedRecipesLength = value;

    notifyListeners();
  }

  changeSelectedCollection(CollectionType collectionType) {
    switch (collectionType) {
      case CollectionType.draft:
        selectedCollectionType=CollectionType.draft;
        nftList= nftdraftList;
        notifyListeners();
        break;
      case CollectionType.published:
        selectedCollectionType=CollectionType.published;
        nftList= publishedNFTsList;
        notifyListeners();
        break;
      case CollectionType.forSale:
        selectedCollectionType=CollectionType.forSale;
        nftList= forSaleList;
        notifyListeners();
        break;
    }
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

  List<NFT> nftList = [];

  List<NFT> forSaleList = [];

  final List<NFT> _publishedNFTsList = [];

  List<NFT> get publishedNFTsList => _publishedNFTsList;

  String? getCookbookIdFromLocalDatasource() {
    return repository.getCookbookId();
  }

  void getTotalForSale() {
    forSaleCount = 0;
    forSaleList=[];
    for (int i = 0; i < _publishedNFTsList.length; i++) {
      if (publishedNFTsList[i].isEnabled && publishedNFTsList[i].amountMinted < publishedNFTsList[i].quantity) {
        forSaleCount++;
        forSaleList.add(publishedNFTsList[i]);
      }
    }
  }

  Future<void> getPublishAndDraftData() async {
    await Future.wait([getRecipesList(), getDraftsList()]);

    getTotalForSale();
    nftList = nftdraftList;
    notifyListeners();
  }

  Future<void> getRecipesList() async {
    final isPylonsExist = await PylonsWallet.instance.exists();

    if (!isPylonsExist) {
      return;
    }
    final cookBookId = getCookbookIdFromLocalDatasource();
    if (cookBookId == null) {
      return;
    }

    final recipesListEither = await repository.getRecipesBasedOnCookBookId(cookBookId: cookBookId);

    if (recipesListEither.isLeft()) {
      return;
    }

    final recipesList = recipesListEither.getOrElse(() => []);
    _publishedNFTsList.clear();
    if (recipesList.isEmpty) {
      return;
    }
    for (final recipe in recipesList) {
      final nft = NFT.fromRecipe(recipe);

      _publishedNFTsList.add(nft);
    }

    publishedRecipeLength = _publishedNFTsList.length;
  }

  Future<void> getDraftsList() async {
    final loading = Loading().showLoading(message: "loading".tr());

    final getNftResponse = await repository.getNfts();

    if (getNftResponse.isLeft()) {
      loading.dismiss();

      "something_wrong".tr().show();

      return;
    }

    nftdraftList = getNftResponse.getOrElse(() => []);

    loading.dismiss();

    notifyListeners();
  }

  Future<void> deleteNft(int? id) async {
    final deleteNftResponse = await repository.deleteNft(id!);

    if (deleteNftResponse.isLeft()) {
      "delete_error".tr().show();
      return;
    }
    nftdraftList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void saveNFT({required NFT nft}) {
    repository.setCacheDynamicType(key: nftKey, value: nft);
    repository.setCacheString(key: fromKey, value: kDraft);
  }

  void updateViewType(ViewType selectedViewType){

    viewType= selectedViewType;
    notifyListeners();
  }
}
