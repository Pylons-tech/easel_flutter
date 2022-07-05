import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/custom_widgets/step_labels.dart';
import 'package:easel_flutter/screens/custom_widgets/steps_indicator.dart';
import 'package:easel_flutter/screens/describe_screen.dart';
import 'package:easel_flutter/screens/mint_screen.dart';
import 'package:easel_flutter/screens/price_screen.dart';
import 'package:easel_flutter/screens/published_screen.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/screens/publish_screen.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

import '../models/nft.dart';
import 'choose_format_screen.dart';
import 'custom_widgets/step_labels.dart';
import 'custom_widgets/steps_indicator.dart';
import 'mint_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late EaselProvider easelProvider;
  late HomeViewModel homeViewModel;
  var repository = GetIt.I.get<Repository>();

  NFT? nft;
  String? from;
  final List pageTitles = ["select_nft_file".tr(), "nft_detail_text".tr(), "nft_pricing".tr(), ''];

  @override
  void initState() {
    easelProvider = Provider.of<EaselProvider>(context, listen: false);
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    homeViewModel.init(setTextField: () {
      easelProvider.setTextFieldValuesDescription(artName: homeViewModel.nft?.name, description: homeViewModel.nft?.description);
      easelProvider.setTextFieldValuesPrice(
          royalties: homeViewModel.nft?.tradePercentage, price: homeViewModel.nft?.price, edition: homeViewModel.nft?.quantity.toString(), denom: homeViewModel.nft?.denom);
    });

    Future.delayed(const Duration(milliseconds: 10), () {
      context.read<EaselProvider>().initStore();
    });
    super.initState();
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
                MyStepsIndicator(currentPage: homeViewModel.currentPage, currentStep: homeViewModel.currentStep),
                const VerticalSpace(5),
                StepLabels(currentPage: homeViewModel.currentPage, currentStep: homeViewModel.currentStep),
                const VerticalSpace(10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ValueListenableBuilder(
                          valueListenable: homeViewModel.currentPage,
                          builder: (_, int currentPage, __) => Padding(
                              padding: EdgeInsets.only(left: 10.sp),
                              child: IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  homeViewModel.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                                  if (homeViewModel.currentPage.value == 0) {
                                    context.read<CreatorHubViewModel>().getDraftsList();
                                    Navigator.of(context).pop();
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: EaselAppTheme.kGrey,
                                ),
                              )),
                        )),
                    ValueListenableBuilder(
                      valueListenable: homeViewModel.currentPage,
                      builder: (_, int currentPage, __) {
                        return Text(
                          pageTitles[homeViewModel.currentPage.value],
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
                    controller: homeViewModel.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int page) {
                      homeViewModel.currentPage.value = page;
                      switch (page) {
                        case 0:
                          homeViewModel.currentStep.value = 0;
                          break;
                        case 1:
                        case 2:
                          homeViewModel.currentStep.value = 1;
                          break;

                        case 3:
                          homeViewModel.currentStep.value = 2;
                          break;
                      }
                    },
                    children: [
                      ChooseFormatScreen(controller: homeViewModel.pageController),
                      DescribeScreen(controller: homeViewModel.pageController),
                      PriceScreen(controller: homeViewModel.pageController),
                      MintScreen(controller: homeViewModel.pageController),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getCurrentPageExecution({required EaselProvider easelProvider}) {
    switch (homeViewModel.currentPage.value) {
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
  }
}
