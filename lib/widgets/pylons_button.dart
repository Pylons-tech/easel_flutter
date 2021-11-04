import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';

class PylonsButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PylonsButton({
    Key? key,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Padding(
        padding:  EdgeInsets.only(right: 20.0),
        child:  Text("Mint", style: TextStyle(color: Colors.white, fontSize: 16),),
      ),
      label: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      style: TextButton.styleFrom(
        backgroundColor: kBlue,
        padding: const EdgeInsets.only(left: 50, right: 10, top: 10, bottom: 10),
        shadowColor: kBlue,
        elevation: 10
      ),
    );
  }
}
