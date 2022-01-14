
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  String? getCookbookId();
  String? getUsername();
  Future<String> autoGenerateCookbookId();
  String autoGenerateEaselId();
  Future<bool> setUsername(String name);
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
  
  @override
  String? getUsername(){
    return sharedPreferences.getString(kUsername);
  }
  
  @override
  Future<bool> setUsername(String name) async {
    return sharedPreferences.setString(kUsername, name);
  }

  /// auto generates cookbookID string and saves into local storage
  /// returns cookbookId
  @override
  Future<String> autoGenerateCookbookId() async{


    String cookbookId = "Easel_CookBook_auto_cookbook_${getFullDateTime()}";

    await sharedPreferences.setString(kCookbookId, cookbookId);

    return cookbookId;
  }

  /// auto generates easelID string
  /// returns easelId
  @override
  String autoGenerateEaselId() {

    String cookbookId = "Easel_Recipe_auto_recipe_${getFullDateTime()}";

    return cookbookId;
  }



}