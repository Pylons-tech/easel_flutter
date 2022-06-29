import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
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

import 'choose_format_screen.dart';
import 'custom_widgets/step_labels.dart';
import 'custom_widgets/steps_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final int _numPages = 4;
  final PageController _pageController = PageController(keepPage: true, initialPage: 0);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  final ValueNotifier<int> _currentStep = ValueNotifier(0);

  final List pageTitles = [kSelectNFTText, kDetailNftText, kPriceNftText, '', ""];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10), () {
      context.read<EaselProvider>().initStore();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EaselProvider easelProvider = context.read<EaselProvider>();

    return WillPopScope(
      onWillPop: () async {
        await context.read<CreatorHubViewModel>().getDraftsList();

        return true;
      },
      child: Container(
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
                          builder: (_, int currentPage, __) => _currentPage.value == _numPages
                              ? Consumer<EaselProvider>(
                                  builder: (_, provider, __) => TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamedAndRemoveUntil((RouteUtil.ROUTE_CREATOR_HUB), (route) => false);
                                    },
                                    child: Text(
                                      kMintMoreText,
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

                                      switch(_currentPage.value){
                                        case 0:
                                          context.read<CreatorHubViewModel>().getDraftsList();
                                          Navigator.of(context).pop();
                                          break;

                                        case 1:
                                          easelProvider.willLoadFirstTime = true;
                                          break;
                                        case 2:
                                          easelProvider.willLoadFirstTime = false;
                                          break;
                                      }

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
                      switch (page) {
                        case 0:
                          _currentStep.value = 0;
                          break;
                        case 1:
                        case 2:
                          _currentStep.value = 1;
                          break;

                        case 3:
                        case 4:
                          _currentStep.value = 2;
                          break;
                      }
                    },
                    children: [ChooseFormatScreen(controller: _pageController), DescribeScreen(controller: _pageController), PriceScreen(controller: _pageController), MintScreen(controller: _pageController), PublishScreen(controller: _pageController)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
