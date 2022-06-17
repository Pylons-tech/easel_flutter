import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatorHubScreen extends StatefulWidget {
  const CreatorHubScreen({Key? key}) : super(key: key);

  @override
  State<CreatorHubScreen> createState() => _CreatorHubScreenState();
}

class _CreatorHubScreenState extends State<CreatorHubScreen> {
  bool collapsed = true;

  TextStyle titleStyle = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: EaselAppTheme.kBlack);
  @override
  Widget build(BuildContext context) {
    return Container(
        color: EaselAppTheme.kWhite,
        child: SafeArea(
            child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Text("creator_hub".tr(), style: titleStyle),
                     Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pushNamed(RouteUtil.ROUTE_HOME);

                        },
                        child:  Icon(
                          Icons.add,
                          size: 30.h,
                          color: EaselAppTheme.kBlack,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  children: [
                    Expanded(child: buildCard(title: "for_sale".tr(), cardColor: EaselAppTheme.kBlue)),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(child: buildCard(title: "publish".tr(), cardColor: EaselAppTheme.kDarkGreen)),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(child: buildCard(title: "draft".tr(), cardColor: EaselAppTheme.kLightRed))
                  ],
                ),
                SizedBox(height: 30.h),
                animatedContainer(title: "publish_total".tr(args: ["0"])),
                SizedBox(height: 20.h),
                animatedContainer(title: "draft_total".tr(args: ["0"]))
              ],
            ),
          ),
        )));
  }

  Widget animatedContainer({required String title}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: collapsed ? 40.h : 150.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 120.w,
                          height: 23.h,
                          child: Text(
                            title,
                            maxLines: 1,
                            style: titleStyle.copyWith(fontSize: 15.sp),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              collapsed = !collapsed;
                            });
                          },
                          child: SizedBox(height: 20.h, width: 20.w, child: const Icon(Icons.add)),
                        )
                      ],
                    ),
                    Wrap(
                      children: [
                        Container(
                          width: 120.w,
                          height: 10.h,
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: EaselAppTheme.kBlack, width: 2))),
                        ),
                        CustomPaint(size: Size(10.w, 10.h), painter: DiagonalLinePainter()),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required String title,
    required Color cardColor,
  }) {
    return Container(
        color: cardColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w400, fontSize: 12.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "-",
                style: TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w400, fontSize: 12.sp),
              )
            ],
          ),
        ));
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final point1 = Offset(-0.5, size.height - 1);
    final point2 = Offset(size.width, 0);
    final paint = Paint()
      ..color = EaselAppTheme.kBlack
      ..strokeWidth = 2;
    canvas.drawLine(point1, point2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}