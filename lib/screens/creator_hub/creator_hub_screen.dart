
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';

class CreatorHubScreen extends StatefulWidget {
  const CreatorHubScreen({Key? key}) : super(key: key);

  @override
  State<CreatorHubScreen> createState() => _CreatorHubScreenState();
}

class _CreatorHubScreenState extends State<CreatorHubScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: EaselAppTheme.kWhite,
        child:  SafeArea(
        child: Scaffold(
          body:
          Text("gfg"),
        )));
  }
}
