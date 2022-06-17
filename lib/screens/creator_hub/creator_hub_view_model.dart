import 'dart:convert';

import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/models/draft.dart';
import 'package:flutter/cupertino.dart';

class CreatorHubViewModel extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  CreatorHubViewModel(this.localDataSource, this.remoteDataSource);

  saveDraft(file) {
    List<int> imageBytes = file.readAsBytesSync();
    final base64Image = base64Encode(imageBytes);

    Draft draft = Draft(null, base64Image);
    localDataSource.saveDraft(draft);
  }
}
