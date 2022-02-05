import 'package:easel_flutter/utils/constants.dart';

class Denom {
  final String name;
  final String symbol;

  Denom({required this.name, required this.symbol});
  
  
  static List<Denom> get availableDenoms => [
    Denom(name: "Pylon", symbol: kPylonSymbol),
    Denom(name: "USD", symbol: kUsdSymbol),
    Denom(name: "Atom", symbol: kAtomSymbol),
    Denom(name: "EEur", symbol: kEuroSymbol),
    Denom(name: "Agoric", symbol: kAgoricSymbol),
  ];

}