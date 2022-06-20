
import 'package:flutter/cupertino.dart';

import '../../services/datasources/local_datasource.dart';
import '../../services/datasources/remote_datasource.dart';

class CreatorHubViewModel extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  CreatorHubViewModel(this.localDataSource, this.remoteDataSource);

}
