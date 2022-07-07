import 'package:easel_flutter/utils/amount_formatter.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Denom {
  final String name;
  final String symbol;
  final String icon;

  Denom({required this.name, required this.symbol, required this.icon});

  factory Denom.initial() {
    return Denom(icon: '', name: '', symbol: '');
  }

  static List<Denom> get availableDenoms => [
        Denom(name: kUSDText, symbol: kUsdSymbol, icon: kIconDenomUsd),
        Denom(name: kPylonText, symbol: kPylonSymbol, icon: kIconDenomPylon),
        Denom(name: kAtomText, symbol: kAtomSymbol, icon: kIconDenomAtom),
        Denom(name: kEurText, symbol: kEuroSymbol, icon: kIconDenomEmoney),
        Denom(name: kAgoricText, symbol: kAgoricSymbol, icon: kIconDenomAgoric),
        Denom(name: kJunoText, symbol: kJunoSymbol, icon: kIconDenomJuno),
        Denom(name: kEthereum, symbol: kEthereumSymbol, icon: kIconDenomETH),
      ];

  TextInputFormatter getFormatter() {
    if (symbol == kPylonSymbol) {
      return AmountFormatter(maxDigits: kMaxPriceLength, isDecimal: false);
    }
    return AmountFormatter(maxDigits: kMaxPriceLength, isDecimal: true);
  }

  @override
  String toString() {
    return 'Denom{name: $name, symbol: $symbol, icon: $icon}';
  }

  Widget getIconWidget() {
    switch (symbol) {
      case kUsdSymbol:
      case kPylonSymbol:
      case kAtomSymbol:
      case kEuroSymbol:
      case kAgoricSymbol:
      case kJunoSymbol:
        return Image.asset(icon);
      case kEthereumSymbol:
        return Container(padding: EdgeInsets.symmetric(vertical: 10.h), child: Image.asset(icon));

      default:
        return Image.asset(icon);
    }
  }

  String formatAmount({required String price}) {
    switch (symbol) {
      case kUsdSymbol:
      case kPylonSymbol:
      case kAtomSymbol:
      case kEuroSymbol:
      case kAgoricSymbol:
      case kJunoSymbol:
        return (double.parse(price.replaceAll(",", "").trim()) * kBigIntBase).toStringAsFixed(0);
      case kEthereumSymbol:
        return (double.parse(price.replaceAll(",", "").trim()) * kEthIntBase).toStringAsFixed(0);
      default:
        return (double.parse(price.replaceAll(",", "").trim()) * kBigIntBase).toStringAsFixed(0);
    }
  }
}
