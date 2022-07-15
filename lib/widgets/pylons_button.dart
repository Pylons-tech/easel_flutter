import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PylonsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final bool showArrow;
  final bool isBlue;
  final bool isRed;
  final double mobileScreenButtonWidth;

  const PylonsButton({Key? key, this.isBlue = true, this.isRed = true, this.showArrow = false, required this.btnText, required this.onPressed, this.mobileScreenButtonWidth = 0.5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: ClipPath(
        clipper: PylonsButtonClipper(),
        child: Container(
          width: isTablet ? 0.3.sw : mobileScreenButtonWidth.sw,
          height: isTablet ? 0.07.sw : 0.12.sw,
          decoration: BoxDecoration(
            color: isBlue
                ? EaselAppTheme.kBlue
                : isRed
                    ? EaselAppTheme.kRed
                    : EaselAppTheme.kDartGrey02,
          ),
          child: Stack(
            children: [
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
        ),
      ),
    );
  }
}

class PylonsButtonClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(size.width * 0.8991000, 0);
    path0.lineTo(size.width, size.height * 0.3484000);
    path0.lineTo(size.width, size.height);
    path0.lineTo(size.width * 0.1008500, size.height);
    path0.lineTo(0, size.height * 0.6466000);
    path0.lineTo(0, 0);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return oldClipper != this;
  }
}
