import 'dart:math';

import 'package:easel_flutter/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  String? getCookbookId();
  Future<String> autoGenerateCookbookId();
  String autoGenerateEaselId();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl(this.sharedPreferences);

  /// gets cookbookId from local storage
  ///return String or null
  @override
  String? getCookbookId(){
    return sharedPreferences.getString(kCookbookId);
  }

  /// auto generates cookbookID string and saves into local storage
  /// returns cookbookId
  @override
  Future<String> autoGenerateCookbookId() async{

    final format = DateFormat('yyyy_MM_dd_HHmmss_SSS');
    String cookbookId = "Easel_CookBook_autocookbook_${format.format(DateTime.now())}";

    await sharedPreferences.setString(kCookbookId, cookbookId);

    return cookbookId;
  }

  /// auto generates easelID string
  /// returns easelId
  @override
  String autoGenerateEaselId() {

    final format = DateFormat('yyyy_MM_dd_HHmmss_SSS');
    String cookbookId = "Easel_Recipe_autorecipe_${format.format(DateTime.now())}";

    return cookbookId;
  }



}