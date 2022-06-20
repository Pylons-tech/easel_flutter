import 'dart:core';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:equatable/equatable.dart';
import "package:collection/collection.dart";
import 'package:pylons_sdk/pylons_sdk.dart';

class NFT extends Equatable {
  String url = "";
  String thumbnailUrl = "";
  String name = "";
  String description = "";
  String denom = "";
  String price = "0";
  String creator = "";
  String owner = "";
  int amountMinted = 0;
  int quantity = 0;
  String tradePercentage = "0";
  String cookbookID = "";
  String recipeID = "";
  String itemID = "";
  String width = "";
  String height = "";
  String appType = "";
  String tradeID = "";
  String ownerAddress = "";
  IBCCoins ibcCoins = IBCCoins.upylon;

  NftType type = NftType.TYPE_ITEM;
  AssetType assetType = AssetType.Image;
  String duration = "";
  String hashtags = "";

  NFT({
    this.url = "",
    this.thumbnailUrl = "",
    this.name = "",
    this.description = "",
    this.denom = "",
    this.price = "0",
    this.type = NftType.TYPE_ITEM,
    this.creator = "",
    this.itemID = "",
    this.cookbookID = "",
    this.recipeID = "",
    this.owner = "",
    this.width = "",
    this.height = "",
    this.tradePercentage = "0",
    this.amountMinted = 0,
    this.quantity = 0,
    this.appType = "",
    required this.ibcCoins,
    this.tradeID = "",
    this.assetType = AssetType.Image,
    this.duration = "",
    this.hashtags = "",
  });

  factory NFT.fromRecipe(Recipe recipe) {
    final royalties = recipe.entries.itemOutputs.firstOrNull?.tradePercentage.fromBigInt().toInt().toString();
    return NFT(
      type: NftType.TYPE_RECIPE,
      recipeID: recipe.iD,
      cookbookID: recipe.cookbookID,
      name: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kName, orElse: () => StringParam()).value ?? "",
      url: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kNFTURL, orElse: () => StringParam()).value ?? "",
      thumbnailUrl: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kThumbnailUrl, orElse: () => StringParam()).value ?? "",
      description: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kDescription, orElse: () => StringParam()).value ?? "",
      appType: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kAppType, orElse: () => StringParam()).value ?? "",
      creator: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kCreator, orElse: () => StringParam()).value ?? "",
      width: recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((longKeyValue) => longKeyValue.key == kWidth, orElse: () => LongParam()).weightRanges.firstOrNull?.upper.toString() ?? "0",
      height: recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((longKeyValue) => longKeyValue.key == kHeight, orElse: () => LongParam()).weightRanges.firstOrNull?.upper.toString() ?? "0",
      amountMinted: int.parse(recipe.entries.itemOutputs.firstOrNull?.amountMinted.toString() ?? "0"),
      quantity: recipe.entries.itemOutputs.firstOrNull?.quantity.toInt() ?? 0,
      tradePercentage: royalties == null ? kNone : "$royalties%",
      price: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.amount ?? "0",
      denom: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.denom ?? "",
      ibcCoins: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.denom.toIBCCoinsEnum() ?? IBCCoins.upylon,
      assetType: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kNftFormat, orElse: () => StringParam()).value.toAssetTypeEnum() ?? AssetType.Image,
      duration:
          recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((longKeyValue) => longKeyValue.key == kDuration, orElse: () => LongParam()).weightRanges.firstOrNull?.upper.toInt().toSeconds() ??
              "0",
      hashtags: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kHashtags, orElse: () => StringParam()).value ?? "",
    );
  }

  @override
  List<Object?> get props => [
        url,
        name,
        description,
        denom,
        price,
        type,
        creator,
        itemID,
        owner,
      ];
}
