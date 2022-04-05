import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:easel_flutter/screens/welcome_screen.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import '../utils/constants.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  BottomDrawerController myBottomDrawerController = BottomDrawerController();

  late List<Widget> slides;

  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
      (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: currentPage.round() == index ? 18.w : 12.h,
            width: currentPage.round() == index ? 18.w : 12.h,
            decoration: BoxDecoration(
              color: currentPage.round() == index ? getColorPerPage(index) : EaselAppTheme.kLightGrey,
            ),
          ));

  double currentPage = 0.0;
  final _pageViewController = PageController();

  Color getColorPerPage(int index) {
    switch (index) {
      case 0:
        return EaselAppTheme.kDarkGreen;
      case 1:
        return EaselAppTheme.kYellow;
      case 2:
        return EaselAppTheme.kLightRed;
      default:
        return EaselAppTheme.kLightGrey;
    }
  }

  @override
  void initState() {
    super.initState();
    myBottomDrawerController = BottomDrawerController();
    slides = kTutorialItems
        .map((item) => Column(
              children: <Widget>[
                SizedBox(height: 0.2.sh),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.22.sw),
                    child: Image.asset(
                      item['image'],
                      fit: BoxFit.contain,
                    )),
                if (kTutorialItems.indexOf(item) == kTutorialItems.length - 1) ...[
                  SizedBox(
                    height: 0.15.sh,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 10.w, bottom: 2.h),
                          padding: EdgeInsets.only(bottom: 8.h),
                          width: 0.17.sh,
                          height: 0.08.sh,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage(kTooltipBalloon), fit: BoxFit.contain),
                          ),
                          child: Text(
                            kWhyAppNeeded,
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kWhite),
                          ),
                        ),
                        onTap: () {
                          /// To-Do: bottom drawer that explains why the pylons app is required
                          myBottomDrawerController.open();
                        },
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: EaselAppTheme.kDartGrey),
                      children: <TextSpan>[
                        TextSpan(text: item['header']),
                        TextSpan(text: item['header1'], style: const TextStyle(color: EaselAppTheme.kPurple02)),
                      ],
                    ),
                  )
                ] else ...[
                  SizedBox(height: 0.15.sh),
                  Text(item['header'],
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: EaselAppTheme.kDartGrey),
                      textAlign: TextAlign.center),
                ],
                const SizedBox(height: 15),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(item['description'],
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center)),
              ],
            ))
        .toList();
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EaselAppTheme.kWhite03,
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageViewController,
            itemCount: slides.length,
            itemBuilder: (BuildContext context, int index) {
              return slides[index];
            },
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 120.h),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicator(),
                ),
              )
              //  ),
              ),
          if (currentPage.round() == slides.length - 1) ...[
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(right: 25.w, bottom: 40.h),
                  child: PylonsButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamed(RouteUtil.ROUTE_WELCOME);
                    },
                    btnText: kContinue,
                    isBlue: false,
                  ),
                )
                //  ),
                ),
            buildBottomDrawer(context),
          ]
          // )
        ],
      ),
    );
  }

  Widget buildBottomDrawer(BuildContext context) {
    return BottomDrawer(
      header: Container(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: const BoxDecoration(
                      color: EaselAppTheme.kLightRed,
                      shape: BoxShape.rectangle,
                    )),
                SizedBox(width: 24.w),
                SizedBox(
                  width: 0.7.sw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kWhyAppNeededDesc1,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: Colors.black)),
                      SizedBox(height: 8.h),
                      Text(kWhyAppNeededDescSummary1,
                          style:
                              TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kLightGrey))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: const BoxDecoration(
                      color: EaselAppTheme.kYellow,
                      shape: BoxShape.rectangle,
                    )),
                SizedBox(width: 24.w),
                SizedBox(
                  width: 0.7.sw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kWhyAppNeededDesc2,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: Colors.black)),
                      SizedBox(height: 8.h),
                      Text(kWhyAppNeededDescSummary2,
                          style:
                              TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kLightGrey))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: const BoxDecoration(
                      color: EaselAppTheme.kDarkGreen,
                      shape: BoxShape.rectangle,
                    )),
                SizedBox(width: 24.w),
                SizedBox(
                  width: 0.7.sw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kWhyAppNeededDesc3,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: Colors.black)),
                      SizedBox(height: 8.h),
                      Text(kWhyAppNeededDescSummary3,
                          style:
                              TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kLightGrey))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.center,
              child: PylonsButton(
                onPressed: () async {
                  final appAlreadyInstalled = await PylonsWallet.instance.exists();
                  if (!appAlreadyInstalled) {
                    PylonsWallet.instance.goToInstall();
                  } else {
                    ScaffoldHelper(context).show(message: kPylonsAlreadyInstalled);
                  }
                },
                btnText: kDownloadPylons,
              ),
            )
          ],
        ),
      ),
      headerHeight: 0,
      drawerHeight: 0.5.sh,
      color: EaselAppTheme.kLightGrey02,
      controller: myBottomDrawerController,
    );
  }
}
