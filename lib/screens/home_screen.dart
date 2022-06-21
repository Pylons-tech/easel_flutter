import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/custom_widgets/step_labels.dart';
import 'package:easel_flutter/screens/custom_widgets/steps_indicator.dart';
import 'package:easel_flutter/screens/describe_screen.dart';
import 'package:easel_flutter/screens/mint_screen.dart';
import 'package:easel_flutter/screens/price_screen.dart';
import 'package:easel_flutter/screens/publish_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import 'choose_format_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final int _numPages = 5;
  final PageController _pageController = PageController(keepPage: true);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  static const _kPageList = 3;

  final int _numSteps = 4;
  final ValueNotifier<int> _currentStep = ValueNotifier(0);

  final List pageTitles = [kUploadNFTText, kDescribeNftText, kPriceNftText, kListNftText, ''];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  gotoDashBoard() {
    Navigator.of(context).pushNamedAndRemoveUntil((RouteUtil.ROUTE_CREATOR_HUB), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EaselAppTheme.kWhite,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const VerticalSpace(20),
              MyStepsIndicator(currentPage: _currentPage, currentStep: _currentStep),
              const VerticalSpace(5),
              StepLabels(currentPage: _currentPage, currentStep: _currentStep),
              const VerticalSpace(10),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: ValueListenableBuilder(
                        valueListenable: _currentPage,
                        builder: (_, int currentPage, __) => _currentPage.value == _numPages - 1
                            ? Consumer<EaselProvider>(
                                builder: (_, provider, __) => TextButton(
                                  onPressed: () {
                                    provider.initStore();
                                    gotoDashBoard();
                                  },
                                  child: Text(
                                    kGotoDashboard,
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20.sp, color: EaselAppTheme.kBlue, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(left: 10.sp),
                                child: IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: EaselAppTheme.kGrey,
                                  ),
                                )),
                      )),
                  ValueListenableBuilder(
                    valueListenable: _currentPage,
                    builder: (_, int currentPage, __) {
                      return Text(
                        pageTitles[_currentPage.value],
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kDarkText),
                      );
                    },
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ValueListenableBuilder(
                        valueListenable: _currentPage,
                        builder: (_, int currentPage, __) => _currentPage.value == _numPages - 1
                            ? Consumer<EaselProvider>(
                                builder: (_, provider, __) => TextButton.icon(
                                  onPressed: () {
                                    PylonsWallet.instance.goToPylons();
                                  },
                                  label: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: EaselAppTheme.kBlue,
                                    size: 18,
                                  ),
                                  icon: Text(
                                    kGoToWalletText,
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20.sp, color: EaselAppTheme.kBlue, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ))
                ],
              ),
              ScreenResponsive(
                mobileScreen: (context) => const VerticalSpace(6),
                tabletScreen: (context) => const VerticalSpace(30),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) {
                    _currentPage.value = page;
                    _currentStep.value = page < _kPageList ? page : _numSteps - 1;
                  },
                  children: [
                    ChooseFormatScreen(controller: _pageController),
                    DescribeScreen(controller: _pageController),
                    PriceScreen(controller: _pageController),
                    MintScreen(controller: _pageController),
                    PublishScreen(controller: _pageController)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
