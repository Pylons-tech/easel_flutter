import 'package:easel_flutter/utils/amount_formatter.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/services.dart';

class Denom {
  final String name;
  final String symbol;

  Denom({required this.name, required this.symbol});

  static List<Denom> get availableDenoms => [
        Denom(name: kUSDText, symbol: kUsdSymbol),
        Denom(name: kPylonText, symbol: kPylonSymbol),
        Denom(name: kAtomText, symbol: kAtomSymbol),
        Denom(name: kEurText, symbol: kEuroSymbol),
        Denom(name: kAgoricText, symbol: kAgoricSymbol),
        Denom(name: kJunoText, symbol: kJunoSymbol),
        Denom(name: kLunaText, symbol: kLunaSymbol),
        Denom(name: kUSTText, symbol: kUSTSymbol),
      ];

  TextInputFormatter getFormatter() {
    if (symbol == kPylonSymbol) {
      return AmountFormatter(maxDigits: kMaxPriceLength, isDecimal: false);
    }
    return AmountFormatter(maxDigits: kMaxPriceLength, isDecimal: true);
  }
}
