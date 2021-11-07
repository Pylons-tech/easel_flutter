import 'dart:math';

import 'package:easel_flutter/utils/constants.dart';
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
    final rnd = Random();
    int randomNo = rnd.nextInt(1000000);
    String cookbookId = "Easel_CookBook_autocookbook_$randomNo";

    await sharedPreferences.setString(kCookbookId, cookbookId);

    return cookbookId;
  }

  /// auto generates easelID string
  /// returns easelId
  @override
  String autoGenerateEaselId() {
    final rnd = Random();
    int randomNo = rnd.nextInt(1000000);
    String cookbookId = "Easel_Recipe_autorecipe_$randomNo";

    return cookbookId;
  }



}