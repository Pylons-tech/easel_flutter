
import 'package:easel_flutter/models/draft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DraftsMoreBottomSheet  extends StatelessWidget {
  const DraftsMoreBottomSheet({Key? key, required this.draft}) : super(key: key);

  final Draft draft;

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<CreatorHubViewModel>();
    return ClipPath(
      clipper: BottomSheetClipper(),

      child: Container(
        color: EaselAppTheme.kLightGrey02,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: Wrap(
          children: [
            moreOptionTile(title: "publish", svg: kSvgPublish, onPressed: (){}),
            const Divider(color: EaselAppTheme.kGrey,),
            moreOptionTile(title: "delete", svg: kSvgDelete,
                onPressed: (){

                viewModel.deleteDraft(draft.id);

            }),

            const Divider(color: EaselAppTheme.kGrey,),
            moreOptionTile(title: "view", svg: kSvgView, onPressed: (){}),

          ],
        ),


      ),
    );
  }
}
Widget  moreOptionTile({required String title, required String svg, required Function onPressed}){
  TextStyle titleStyle = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800,fontFamily:  kUniversalFontFamily,  color: EaselAppTheme.kBlack);

  return Padding(
    padding:  EdgeInsets.symmetric(vertical: 8.h),
    child: InkWell(
      onTap: (){

      },
      child: Row(
        children: [
          SvgPicture.asset(svg),

          SizedBox(width: 30.w,),

          Text(title.tr(), style: titleStyle.copyWith(fontSize: 16.sp),)
        ],
      ),
    ),
  );
}

class BottomSheetClipper extends CustomClipper<Path> {
  BottomSheetClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height *0.08.h);
    path.lineTo(size.width*0.05.w, 0);
    path.lineTo(size.width*0.95.w, 0);
    path.lineTo(size.width, size.height*0.08.h);
    path.lineTo(size.width , size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}