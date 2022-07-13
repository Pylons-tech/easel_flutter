import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:flutter/material.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenResponsive(
      mobileScreen: (context) => buildMobileScreen(context),
      tabletScreen: (BuildContext context) => buildTabletScreen(context),
    ));
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

                Navigator.of(context).pushNamed(RouteUtil.kRouteTutorial);


                /// TODO remove the above line after testing
                var onBoardingComplete = GetIt.I.get<LocalDataSource>().getOnBoardingComplete();
                if (onBoardingComplete) {
                  Navigator.of(context).pushNamed(RouteUtil.kRouteWelcome);
                  return;
                }
                Navigator.of(context).pushNamed(RouteUtil.kRouteTutorial);
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
        Container(),
        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: SvgPicture.asset(kSvgTabSplash, fit: BoxFit.fill)),
        Positioned(
          top: 0.26.sh,
          left: 0.2.sw,
          right: 0,
          child: SizedBox(
            height: 0.3.sh,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(alignment: Alignment.centerLeft, child: SvgPicture.asset(kSplashTabEasel)),
                SizedBox(height: 10.h),
                Align(alignment: Alignment.centerLeft, child: SvgPicture.asset(kSplashNFTCreatorTab)),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0.3.sh,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            child: PylonsButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouteUtil.kRouteTutorial);

                /// TODO remove the above line after testing
                var onBoardingComplete = GetIt.I.get<LocalDataSource>().getOnBoardingComplete();
                if (onBoardingComplete) {
                  Navigator.of(context).pushNamed(RouteUtil.kRouteWelcome);
                  return;
                }
                Navigator.of(context).pushNamed(RouteUtil.kRouteTutorial);
              },
              btnText: kGetStarted,
            ),
          ),
        ),
      ],
    );
  }
}
