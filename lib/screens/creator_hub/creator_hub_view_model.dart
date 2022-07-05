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

  List<NFT> nftList = [];

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

  Future<void> getDraftsList() async {
    final loading = Loading().showLoading(message: "loading ...");

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
      nftList.removeWhere((element) => element.id == id);

      notifyListeners();
    }
  }
}