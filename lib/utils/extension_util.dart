import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

extension ScaffoldHelper on BuildContext? {
  void show({required String message}) {
    if (this == null) {
      return;
    }

    ScaffoldMessenger.maybeOf(this!)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        duration: const Duration(seconds: 2),
      ));
  }
}

extension MyBuildContext on GlobalKey<NavigatorState> {
  BuildContext getContext() => navigatorKey.currentState!.overlay!.context;
}

extension NavigatorKey on GlobalKey {
  void showMsg({required String message}) {

    ScaffoldMessenger.maybeOf(currentState!.context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        duration: const Duration(seconds: 2),
      ));
  }
}

extension ValueConverter on String {
  double fromBigInt() {
    if (this == "") {
      return 0;
    }
    return BigInt.parse(this).toDouble() / kPrecision;
  }
}


extension IBCCoinsPar on String {
  IBCCoins toIBCCoinsEnum() {
    if (this == kEthereumSymbol) {
      return IBCCoins.weth_wei;
    }

    return IBCCoins.values.firstWhere((e) {
      return e.toString().toLowerCase() == 'IBCCoins.$this'.toLowerCase();
    }, orElse: () => IBCCoins.none); //return null if not found
  }
}

extension AssetTypePar on String {
  AssetType toAssetTypeEnum() {
    return AssetType.values.firstWhere((e) => e.toString() == 'AssetType.$this', orElse: () => AssetType.Image);
  }
}

extension DurationConverter on int {
  String toSeconds() {
    final double seconds = this / kNumberOfSeconds;
    final String min = (seconds / kSixtySeconds).toString().split(".").first;
    final String sec = (seconds % kSixtySeconds).toString().split(".").first;

    return "$min:$sec";
  }
}

extension NFTValue on NFT {
  String getPriceFromRecipe(Recipe recipe) {
    if (recipe.coinInputs.isEmpty) {
      return "0";
    }
    if (recipe.coinInputs.first.coins.isEmpty) {
      return "0";
    }
    return recipe.coinInputs.first.coins.first.amount;
  }
}
