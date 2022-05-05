import 'package:easel_flutter/utils/amount_formatter.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/services.dart';

class Denom {
  final String name;
  final String symbol;
  final String icon;

  Denom({required this.name, required this.symbol, required this.icon});

  static List<Denom> get availableDenoms => [
        Denom(name: kUSDText, symbol: kUsdSymbol, icon: kIconDenomUsd),
        Denom(name: kPylonText, symbol: kPylonSymbol, icon: kIconDenomPylon),
        Denom(name: kAtomText, symbol: kAtomSymbol, icon: kIconDenomAtom),
        Denom(name: kEurText, symbol: kEuroSymbol, icon: kIconDenomEmoney),
        Denom(name: kAgoricText, symbol: kAgoricSymbol, icon: kIconDenomAgoric),
        Denom(name: kJunoText, symbol: kJunoSymbol, icon: kIconDenomJuno),
        Denom(name: kLunaText, symbol: kLunaSymbol, icon: kIconDenomLuna),
        Denom(name: kUSTText, symbol: kUSTSymbol, icon: kIconDenomUst),
      ];

  TextInputFormatter getFormatter() {
    if (symbol == kPylonSymbol) {
      return AmountFormatter(maxDigits: kMaxPriceLength, isDecimal: false);
    }
    return AmountFormatter(maxDigits: kMaxPriceLength, isDecimal: true);
  }
}
