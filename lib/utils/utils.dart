import 'package:intl/intl.dart';

String formatAmount(String value) {
  final double amount = double.parse(value);
  final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");
   return formatCurrency.format(amount).replaceAll('.00', '');
  // return formatCurrency.format(amount);
}