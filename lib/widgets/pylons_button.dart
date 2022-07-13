import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PylonsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final bool showArrow;
  final bool isBlue;

  const PylonsButton({Key? key, this.isBlue = true, this.showArrow = false, required this.btnText, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
          color: Colors.transparent,
          elevation: 10,
          child: SizedBox(
            width: isTablet ? 0.3.sw : 0.5.sw,
            height: isTablet ? 0.07.sw : 0.12.sw,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: SvgPicture.asset(isBlue ? kSvgRectBlue : kSvgRectRed, fit: BoxFit.cover),
                ),
                if (showArrow)
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: isTablet ? 2.w : 8.w,
                      child: Icon(
                        Icons.arrow_forward,
                        color: EaselAppTheme.kWhite,
                        size: isTablet ? 15.w : 20.w,
                      )),
                Center(
                  child: Text(
                    btnText,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 15.sp, color: EaselAppTheme.kWhite, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          )),
      onTap: () {
        onPressed();
      },
    );
  }
}
