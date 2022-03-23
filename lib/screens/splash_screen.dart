import 'package:easel_flutter/screens/tutorial_screen.dart';
import 'package:easel_flutter/widgets/splash_widget.dart';
import 'package:flutter/material.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(
      children: <Widget>[
        const SplashWidget(),
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 0.3.sh),
            PylonsButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TutorialScreen()),
                );
              },
              btnText: kGetStarted,
              showArrow: false,
            ),
          ],
        ))
      ],
    ));
  }
}
