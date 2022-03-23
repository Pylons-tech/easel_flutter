import 'package:easel_flutter/screens/routing_screen.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  List<Widget> slides = kTutorialItems
      .map((item) => Column(
            children: <Widget>[
              SizedBox(height: 0.2.sh),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.22.sw),
                  child: Image.asset(
                    item['image'],
                    fit: BoxFit.contain,
                  )),
              if (kTutorialItems.indexOf(item) == 2) ...[
                SizedBox(
                  height: 0.15.sh,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 10, bottom: 2),
                        padding: const EdgeInsets.only(bottom: 8),
                        width: 0.17.sh,
                        height: 0.08.sh,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(kTooltipBalloon),
                              fit: BoxFit.contain),
                        ),
                        child: const Text(
                          kWhyAppNeeded,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: EaselAppTheme.kWhite),
                        ),
                      ),
                      onTap: () {
                        print("clicked bubble!");
                      },
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF333333)),
                    children: <TextSpan>[
                      TextSpan(text: item['header']),
                      TextSpan(
                          text: item['header1'],
                          style:
                              const TextStyle(color: EaselAppTheme.kPurple02)),
                    ],
                  ),
                )
              ] else ...[
                SizedBox(height: 0.15.sh),
                Text(item['header'],
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF333333)),
                    textAlign: TextAlign.center),
              ],
              const SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(item['description'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center)),
            ],
          ))
      .toList();

  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: currentPage.round() == index ? 18.0 : 12.0,
            width: currentPage.round() == index ? 18.0 : 12.0,
            decoration: BoxDecoration(
              color: currentPage.round() == index
                  ? getColorPerPage(index)
                  : EaselAppTheme.kLightGrey,
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
                margin: const EdgeInsets.only(bottom: 120.0),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicator(),
                ),
              )
              //  ),
              ),
          if (currentPage.round() == 2) ...[
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 25.0, bottom: 40.0),
                  child: PylonsButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RoutingScreen()),
                      );
                    },
                    btnText: kContinue,
                    showArrow: false,
                    isBlue: false,
                  ),
                )
                //  ),
                ),
          ]
          // )
        ],
      ),
    );
  }
}
