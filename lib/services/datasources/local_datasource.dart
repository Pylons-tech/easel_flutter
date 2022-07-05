import 'package:easel_flutter/datasources/database.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../datasources/cache_manager.dart';

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
  /// Input: [NFT] the draft that will will be saved in database
  /// Output: [int] returns id of the inserted document
  Future<int> saveNft(NFT draft);

  /// This method will get the drafts List from the local database
  /// Output: [List][NFT] returns  the List of drafts
  Future<List<NFT>> getNfts();

  /// This method will get the drafts List from the local database
  /// Output: [List][NFT] returns  the List of drafts
  Future<NFT?> getNft(int id);

  /// This method will update draft in the local database from description Page
  /// Input: [id] the id of the nft,
  /// [String] the  name of the nft , [String] the  description of the nft
  /// [String] the  creator name of the nft , [String] the page name of the Pageview
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> updateNftFromDescription(int id, String nftName, String nftDescription, String creatorName, String step);

  /// This method will update draft in the local database from Pricing page
  /// Input: [id] the id of the nft, [String] the  name of the nft ,
  /// [String] the  tradePercentage of the nft , [String] the  price of the nft
  /// [String] the  quantity of the nft , [String] the page name of the Pageview
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> updateNftFromPrice(int id, String tradePercentage, String price, String quantity, String step, String name, bool isFreeDrop);

  /// This method will delete draft from the local database
  /// Input: [id] the id of the draft which the user wants to delete
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> deleteNft(int id);

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  String getCacheString({required String key});

  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [value] will return the value that is just removed
  String deleteCacheString({required String key});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  void setCacheString({required String key, required String value});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  bool setCacheDynamicType({required String key, required dynamic value});

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  dynamic getCacheDynamicType({required String key});

  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [value] will return the value that is just removed
  dynamic deleteCacheDynamic({required String key});
}

class LocalDataSourceImpl implements LocalDataSource {
  static const String ONBOARDING_COMPLETE = "";

  final SharedPreferences sharedPreferences;

  final AppDatabase database;

  final CacheManager cacheManager;

  LocalDataSourceImpl({required this.sharedPreferences, required this.database, required this.cacheManager});

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
  Future<int> saveNft(NFT draft) async {
    try {
      final result = await database.nftDao.insertNft(draft);
      return result;
    } catch (e) {
      throw "";
    }
  }

  @override
  Future<bool> updateNftFromDescription(int id, String nftName, String nftDescription, String creatorName, String step) async {
    try {
      await database.nftDao.updateNFTFromDescription(id, nftName, nftDescription, creatorName, step);
      return true;
    } catch (e) {
      return throw "";
    }
  }

  @override
  Future<bool> updateNftFromPrice(int id, String tradePercentage, String price, String quantity, String step, String denom, bool isFreeDrop) async {
    try {
      await database.nftDao.updateNFTFromPrice(id, tradePercentage, price, quantity, step, denom, isFreeDrop);
      return true;
    } catch (e) {
      return throw "";
    }
  }

  @override
  Future<List<NFT>> getNfts() async {
    return await database.nftDao.findAllNft();
  }

  @override
  Future<bool> deleteNft(int id) async {
    try {
      await database.nftDao.delete(id);

      return true;
    } catch (e) {
      return throw "";
    }
  }

  @override
  String deleteCacheString({required String key}) {
    return cacheManager.deleteString(key: key);
  }

  @override
  dynamic getCacheDynamicType({required String key}) {
    return cacheManager.getDynamicType(key: key);
  }

  @override
  String getCacheString({required String key}) {
    return cacheManager.getString(key: key);
  }

  @override
  bool setCacheDynamicType({required String key, required value}) {
    return cacheManager.setDynamicType(key: key, value: value);
  }

  @override
  void setCacheString({required String key, required String value}) {
    cacheManager.setString(key: key, value: value);
  }

  @override
  deleteCacheDynamic({required String key}) {
    cacheManager.deleteCacheDynamic(key: key);
  }

  @override
  Future<NFT?> getNft(int id) async {
    try {
      return await  database.nftDao.findNftById(id);
    } catch (e) {
      return throw "";
    }
  }
}
