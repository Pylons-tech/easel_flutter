import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:flutter/material.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenResponsive(mobileScreen: (context) => buildMobileScreen(context), tabletScreen: (BuildContext context)  =>  buildTabletScreen(context),));
  }

  Stack buildMobileScreen(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: SvgPicture.asset(kSvgSplash, fit: BoxFit.cover)),
        Positioned(
          top: 0.3.sh,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            child: PylonsButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouteUtil.ROUTE_TUTORIAL);
              },
              btnText: kGetStarted,
            ),
          ),
        ),
      ],
    );
  }



  Stack buildTabletScreen(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: SvgPicture.asset(kSvgSplash, fit: BoxFit.fill)),
        Positioned(

          bottom: 0.3.sh,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,

            child: PylonsButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouteUtil.ROUTE_TUTORIAL);
              },
              btnText: kGetStarted,
            ),
          ),
        ),
      ],
    );
  }
}
