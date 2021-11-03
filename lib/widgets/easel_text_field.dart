import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EaselTextField extends StatelessWidget {
  const EaselTextField({
    Key? key,
    required this.title,
    this.hint = "",
    this.controller, this.validator,
    this.noOfLines = 1,
    this.inputFormatters = const [],
    this.keyboardType = TextInputType.text
  }) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int noOfLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      minLines: noOfLines,
      maxLines: noOfLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xff1212C4).withOpacity(0.2))
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xff1212C4).withOpacity(0.2))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xff1212C4).withOpacity(0.2))
          ),
          labelText: title,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: hint,
          labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 16
          ),
          floatingLabelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 20
          )
      ),
    );
  }
}