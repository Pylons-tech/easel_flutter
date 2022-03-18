import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: SvgPicture.asset("assets/images/svg/splash.svg",
            fit: BoxFit.cover));
  }
}
