import 'dart:io';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class CreatorHubViewModel extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  CreatorHubViewModel(this.localDataSource, this.remoteDataSource);

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
    nftList = await localDataSource.getNfts();
    print(nftList);
    loading.dismiss();
    notifyListeners();
  }

  Future<void> updateNft() async {
    final loading = Loading().showLoading(message: "loading ...");
    nftList = await localDataSource.getNfts();
    print(nftList);
    loading.dismiss();
    notifyListeners();
  }

  Future<void> deleteNft(int? id) async {
    bool success = await localDataSource.deleteNft(id!);
    if (success) {
      nftList.removeWhere((element) => element.id == id);
    }

    if (!success) {
      navigatorKey.currentState!.overlay!.context.show(message: "delete_error".tr());
    }
    notifyListeners();
  }
}
