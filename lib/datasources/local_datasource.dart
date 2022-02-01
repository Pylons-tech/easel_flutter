
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  String? getCookbookId();
  Future<String> autoGenerateCookbookId();
  String autoGenerateEaselId();



  /// This method will save the username of the cookbook generator
  /// Input: [username] the username of the user who created the cookbook
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveCookBookGeneratorUsername(String username);




  /// This method will get the username of the cookbook generator
  /// Output: [String] returns whether the operation is successful or not
  String getCookBookGeneratorUsername();


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

  @override
  Future<bool> saveCookBookGeneratorUsername(String username) async {
    await sharedPreferences.setString(kUsername, username);
    return true;
  }

  @override
  String getCookBookGeneratorUsername() {
    return  sharedPreferences.getString(kUsername) ?? '';
  }



}