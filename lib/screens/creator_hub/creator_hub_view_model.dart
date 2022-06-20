import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:flutter/cupertino.dart';

class CreatorHubViewModel extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  CreatorHubViewModel({required this.localDataSource, required this.remoteDataSource});
}
