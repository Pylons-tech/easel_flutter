import 'package:easel_flutter/datasources/database.dart';
import 'package:easel_flutter/models/draft.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  /// This method will get the already created cookbook from the local database
  /// Output: [String] if the cookbook already exists return cookbook else return null
  String? getCookbookId();

  /// This method will generate the cookbook id for the easel app
  /// Output: [String] the id of the cookbook which will contains all the NFTs.
  Future<String> autoGenerateCookbookId();

  /// This method will generate easel Id for the NFT
  /// Output: [String] the id of the NFT that is going to be added in the recipe
  String autoGenerateEaselId();

  /// This method will save the username of the cookbook generator
  /// Input: [username] the username of the user who created the cookbook
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveCookBookGeneratorUsername(String username);

  /// This method will get the username of the cookbook generator
  /// Output: [String] returns whether the operation is successful or not
  String getCookBookGeneratorUsername();

  /// This method will save the artist name
  /// Input: [name] the name of the artist which the user want to save
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveArtistName(String name);

  /// This method will get the artist name
  /// Output: [String] returns whether the operation is successful or not
  String getArtistName();

  /// This method will save the on boarding complete in the local datastore
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveOnBoardingComplete();

  /// This method will get the on boarding status from the local datastore
  /// Output: [bool] returns whether the operation is successful or not
  bool getOnBoardingComplete();

  /// This method will save the draft of the NFT
  /// Input: [Draft] the draft that will will be saved in database
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveDraft(Draft draft);

  /// This method will get the drafts List from the local database
  /// Output: [List] returns  the List of drafts
  Future<List<Draft>> getDrafts();

  /// This method will delete draft from the local database
  /// Input: [id] the id of the draft which the user wants to delete
  /// Output: [bool] returns whether the operation is successful or not
  Future<void> deleteDraft(int id);
}

class LocalDataSourceImpl implements LocalDataSource {
  static const String ONBOARDING_COMPLETE = "";

  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl(this.sharedPreferences);

  /// gets cookbookId from local storage
  ///return String or null
  @override
  String? getCookbookId() {
    return sharedPreferences.getString(kCookbookId);
  }

  /// auto generates cookbookID string and saves into local storage
  /// returns cookbookId
  @override
  Future<String> autoGenerateCookbookId() async {
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
    return sharedPreferences.getString(kUsername) ?? '';
  }

  @override
  bool getOnBoardingComplete() {
    return sharedPreferences.getBool(ONBOARDING_COMPLETE) ?? false;
  }

  @override
  Future<bool> saveOnBoardingComplete() async {
    return await sharedPreferences.setBool(ONBOARDING_COMPLETE, true);
  }

  @override
  String getArtistName() {
    return sharedPreferences.getString(kArtistName) ?? '';
  }

  @override
  Future<bool> saveArtistName(String name) async {
    await sharedPreferences.setString(kArtistName, name);
    return true;
  }

  @override
  Future<bool> saveDraft(Draft draft) async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    final draftDao = database.draftDao;

    await draftDao.insertDraft(draft);

    return true;
  }

  @override
  Future<List<Draft>> getDrafts() async{

    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    final draftDao = database.draftDao;

    return await draftDao.findAllDrafts();

  }

  @override
  Future<void> deleteDraft(int id) async{

    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    final draftDao = database.draftDao;

    return await draftDao.delete(id);

  }
}
