
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DraftsMoreBottomSheet  extends StatelessWidget {
  const DraftsMoreBottomSheet({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return ClipPath(
      clipper: BottomSheetClipper(),

      child: Container(
        color: EaselAppTheme.kWhite,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: Wrap(
          children: [
            moreOptionTile(title: "publish", svg: kSvgPublish),
            const Divider(color: EaselAppTheme.kGrey,),
            moreOptionTile(title: "delete", svg: kSvgDelete),

            const Divider(color: EaselAppTheme.kGrey,),
            moreOptionTile(title: "view", svg: kSvgView),

          ],
        ),


      ),
    );
  }
}
Widget  moreOptionTile({required String title, required String svg}){
  TextStyle titleStyle = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: EaselAppTheme.kBlack);

  return Padding(
    padding:  EdgeInsets.symmetric(vertical: 8.h),
    child: Row(
      children: [
        SvgPicture.asset(svg),

        SizedBox(width: 30.w,),

        Text(title.tr(), style: titleStyle.copyWith(fontSize: 16.sp),)
      ],
    ),
  );
}

class BottomSheetClipper extends CustomClipper<Path> {
  BottomSheetClipper();
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height *0.1);
    path.lineTo(size.width*0.07, 0);
    path.lineTo(size.width*0.93, 0);
    path.lineTo(size.width, size.height*0.1);
    path.lineTo(size.width , size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}