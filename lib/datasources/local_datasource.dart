import 'dart:math';

import 'package:easel_flutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<String> getCookbookId();
  String autoGenerateEaselId();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<String> getCookbookId() async{
    String cookBookId = sharedPreferences.getString(kCookbookId) ?? "";
    if(cookBookId.isEmpty){
      cookBookId = await _autoGenerateCookbookId();
    }
    return cookBookId;
  }

  Future<String> _autoGenerateCookbookId() async{
    final rnd = Random();
    int randomNo = rnd.nextInt(10000000000);
    String cookbookId = "Easel_CookBook_autocookbook_$randomNo";

    await sharedPreferences.setString(kCookbookId, cookbookId);

    return cookbookId;
  }

  @override
  String autoGenerateEaselId() {
    final rnd = Random();
    int randomNo = rnd.nextInt(10000000000);
    String cookbookId = "Easel_Recipr_autorecipe_$randomNo";


    return cookbookId;
  }



}