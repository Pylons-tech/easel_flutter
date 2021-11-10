import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';

class PylonsButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PylonsButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: Text(
          "Mint",
          style: TextStyle(color: EaselAppTheme.kWhite, fontSize: 16),
        ),
      ),
      label: const Icon(Icons.arrow_forward_ios, color: EaselAppTheme.kWhite),
      style: TextButton.styleFrom(
          backgroundColor: EaselAppTheme.kBlue,
          padding:
              const EdgeInsets.only(left: 50, right: 10, top: 10, bottom: 10),
          shadowColor: EaselAppTheme.kBlue,
          elevation: 10),
    );
  }
}
