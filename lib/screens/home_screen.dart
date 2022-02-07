import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/choose_format_screen.dart';
import 'package:easel_flutter/screens/description_screen.dart';
import 'package:easel_flutter/screens/mint_screen.dart';
import 'package:easel_flutter/screens/publish_screen.dart';
import 'package:easel_flutter/screens/upload_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_size_util.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steps_indicator/steps_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final int _numPages = 5;
  final PageController _pageController = PageController(keepPage: true);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  List screenLabels = [
    kStartText,
    kUploadText,
    kDescriptionText,
    kMintText,
    kPublishText
  ];
  List screenTitles = [
    kChooseNFTFormatText,
    kUploadNFTText,
    kEditNFTText,
    kPreviewNFTText,
    ''
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Container(
      color: EaselAppTheme.kWhite,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const VerticalSpace(20),
              ValueListenableBuilder(
                valueListenable: _currentPage,
                builder: (_, int value, __) => StepsIndicator(
                  selectedStep: _currentPage.value,
                  nbSteps: _numPages,
                  lineLength: screenSize.width(percent: 90) / _numPages,
                  doneLineColor: EaselAppTheme.kLightGrey,
                  undoneLineColor: EaselAppTheme.kLightGrey,
                  doneLineThickness: 1.5,
                  undoneLineThickness: 1.5,
                  unselectedStepColorIn: EaselAppTheme.kLightGrey,
                  unselectedStepColorOut: EaselAppTheme.kLightGrey,
                  doneStepColor: EaselAppTheme.kLightGrey,
                  selectedStepColorIn: EaselAppTheme.kBlue,
                  selectedStepColorOut: EaselAppTheme.kBlue,
                  enableLineAnimation: false,
                  enableStepAnimation: false,
                ),
              ),
              const VerticalSpace(5),
              _buildTitles(screenSize),
              const VerticalSpace(10),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: screenSize.width(percent: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: IconButton(
                            onPressed: () {
                              _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: EaselAppTheme.kGrey,
                            )),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _currentPage,
                        builder: (_, int currentPage, __) {
                          return Text(
                            screenTitles[_currentPage.value],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: EaselAppTheme.kDarkText),
                          );
                        },
                      ),
                      ValueListenableBuilder(
                        valueListenable: _currentPage,
                        builder: (_, int currentPage, __) =>
                            _currentPage.value == _numPages - 1
                                ? Consumer<EaselProvider>(
                                    builder: (_, provider, __) =>
                                        TextButton.icon(
                                      onPressed: () {
                                        provider.initStore();
                                        _pageController.jumpToPage(_pageController.initialPage);
                                      },
                                      label: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: EaselAppTheme.kBlue,
                                        size: 18,
                                      ),
                                      icon: Text(
                                        kMintMoreText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 20,
                                                color: EaselAppTheme.kBlue,
                                                fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalSpace(6),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) {
                    _currentPage.value = page;
                  },
                  children: [
                    ChooseFormatScreen(
                      controller: _pageController,
                    ),
                    UploadScreen(
                      controller: _pageController,
                    ),
                    DescriptionScreen(
                      controller: _pageController,
                    ),
                    MintScreen(
                      controller: _pageController,
                    ),
                    PublishScreen(
                      controller: _pageController,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTitles(ScreenSizeUtil screenSize) {
    return Row(
      children: List.generate(screenLabels.length, (index) {
        return SizedBox(
          width: screenSize.width(percent: 20),
          child: _buildStepTitle(index),
        );
      }),
    );
  }

  Widget _buildStepTitle(int index) {
    return ValueListenableBuilder(
      valueListenable: _currentPage,
      builder: (_, int currentPage, __) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            screenLabels[index],
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: currentPage == index
                    ? EaselAppTheme.kBlack
                    : EaselAppTheme.kGrey),
          ),
        ],
      ),
    );
  }
}
