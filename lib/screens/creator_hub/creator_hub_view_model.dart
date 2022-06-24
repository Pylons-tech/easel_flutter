import 'dart:io';

import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/draft.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class CreatorHubViewModel extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  CreatorHubViewModel(this.localDataSource, this.remoteDataSource);

  List<Draft> draftList = [];

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

  getDraftsList() async {
    final loading = Loading().showLoading(message: "loading ...");

    draftList = await localDataSource.getDrafts();

    loading.dismiss();

    notifyListeners();
  }


  saveDraft(File? file) async {
    final loading = Loading().showLoading(message: "Uploading ...");
    final uploadResponse = await remoteDataSource.uploadFile(file!);
    loading.dismiss();
    if (uploadResponse.status == Status.error) {
      navigatorKey.currentState!.overlay!.context.show(message: uploadResponse.errorMessage ?? kErrUpload);
      return ;
    }
    Draft draft = Draft(null, "$ipfsDomain/${uploadResponse.data?.value?.cid}");
    bool success = await localDataSource.saveDraft(draft);
    if (!success) {
      navigatorKey.currentState!.overlay!.context.show(message: "save_error".tr());
    }
  }

  deleteDraft(int? id) async {
    bool success = await localDataSource.deleteDraft(id!);

    if (!success) {
      navigatorKey.currentState!.overlay!.context.show(message: "delete_error".tr());
    }
    getDraftsList();
  }
}
