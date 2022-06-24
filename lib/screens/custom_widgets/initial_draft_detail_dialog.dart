
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart' as clipper;
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart';
import 'package:easel_flutter/screens/custom_widgets/clipped_button.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle _rowTitleTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize:isTablet? 11.sp: 13.sp);


class DraftDetailDialog extends StatefulWidget {


  const DraftDetailDialog({Key? key}) : super(key: key);

  @override
  State<DraftDetailDialog> createState() => _PayNowWidgetState();
}

class _PayNowWidgetState extends State<DraftDetailDialog> {
  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 65.w : 21.w),
      child: Container(
        color: Colors.black.withOpacity(0.7),
        height: isTablet ? 400.h : 340.h,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 60.h,
                width: 60.h,
                child: ClipPath(
                  clipper: RightTriangleClipper(orientation: clipper.Orientation.Orientation_NW),
                  child: Container(
                    color:  EaselAppTheme.kLightRed,

                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                height: 60.h,
                width: 60.h,
                child: ClipPath(
                  clipper: RightTriangleClipper(orientation: clipper.Orientation.Orientation_SE),
                  child: Container(
                    color: EaselAppTheme.kLightRed,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(   height: 100.h,
                    width: 100.h,color: Colors.red,),

                  SizedBox(
                    height: 30.h,
                  ),

                  buildRow(
                    subtitle:"file.jpeg",
                    title: "upload_to_ipfs".tr(),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  buildRow(
                    subtitle: "x5909yTEo90",
                    title: "content_id".tr(),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),

                  buildRow(
                    subtitle:"View on IPFS",
                    title: "tx_receipt".tr(),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),

                  SizedBox(
                    height: 45.h,
                    width:isTablet? 120.w: 150.w,
                    child: CustomPaintButton(
                        title: "close".tr(),
                        bgColor: Colors.white.withOpacity(0.2),
                        textColor: EaselAppTheme.kWhite,
                        onPressed: () async {
                          Navigator.pop(context);
                        }, cuttingHeight: 15.h,),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRow({required String title, required String subtitle}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
              padding: EdgeInsets.only(left:isTablet? 20.w : 40.w, right: 5.w),
              child: Text(
                title,
                style: _rowTitleTextStyle,
              ),
            )),
        Expanded(
            child: Padding(
              padding: EdgeInsets.only(right:5.w,),
              child: Text(
                subtitle,
                style: subtitle== "view_on_ipfs".tr()? _rowTitleTextStyle.copyWith(color:EaselAppTheme.kLightPurple ): _rowTitleTextStyle,
              ),
            ))
      ],
    );
  }


}
