import 'dart:io';

import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/draft.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/loading.dart';
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

    final loading = Loading().showLoading(message: "Uploading ...");

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
      return false;
    }
    Draft draft = Draft(null, "$ipfsDomain/${uploadResponse.data?.value?.cid}");
    localDataSource.saveDraft(draft);
  }
}
