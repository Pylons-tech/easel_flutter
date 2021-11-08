import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';

class PylonsRoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PylonsRoundButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onPressed,
      child: const Icon(Icons.arrow_forward_ios, color: EaselAppTheme.kWhite),
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15),
          primary: EaselAppTheme.kBlue,
          shadowColor: EaselAppTheme.kBlue,
          elevation: 10),
    );
  }
}
