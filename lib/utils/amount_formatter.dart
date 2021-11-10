import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AmountFormatter extends TextInputFormatter {

  AmountFormatter({required this.maxDigits});

  int maxDigits;



  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    maxDigits = 7;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }
    double value = double.parse(newValue.text);
    final formatter =  NumberFormat("#,###", "en_US");
    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection:  TextSelection.collapsed(offset: newText.length));
  }

}
