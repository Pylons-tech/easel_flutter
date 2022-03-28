import 'package:easel_flutter/screens/routing_screen.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: <Widget>[
          SizedBox(height: 0.2.sh),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              kWelcomeToEaselText,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: EaselAppTheme.kDarkText,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(height: 60.h),
          Text(
            kEaselDescriptionText,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: EaselAppTheme.kDarkText,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 60.h),
          Container(
            alignment: Alignment.topLeft,
            child: PylonsButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RoutingScreen()),
                );
              },
              btnText: kGetStarted,
              isBlue: false,
            ),
          ),
        ],
      ),
    ));
  }
}
