import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/describe_screen.dart';
import 'package:easel_flutter/screens/price_screen.dart';
import 'package:easel_flutter/screens/published_screen.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'choose_format_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late EaselProvider easelProvider;
  var repository = GetIt.I.get<Repository>();

  HomeViewModel get homeViewModel => GetIt.I.get();

  @override
  void initState() {
    easelProvider = Provider.of<EaselProvider>(context, listen: false);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<EaselProvider>().initStore();
    });

    homeViewModel.init(
      setTextField: () {
        easelProvider.setTextFieldValuesDescription(artName: homeViewModel.nft?.name, description: homeViewModel.nft?.description, hashtags: homeViewModel.nft?.hashtags);
        easelProvider.setTextFieldValuesPrice(royalties: homeViewModel.nft?.tradePercentage, price: homeViewModel.nft?.price, edition: homeViewModel.nft?.quantity.toString(), denom: homeViewModel.nft?.denom, freeDrop: homeViewModel.nft!.isFreeDrop);
      },
    );
  }

  @override
  void dispose() {
    homeViewModel.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        GetIt.I.get<CreatorHubViewModel>().getDraftsList();
        easelProvider.videoLoadingError = '';
        easelProvider.isVideoLoading = true;
        Navigator.of(context).pop();

        return false;
      },
      child: Container(
        color: EaselAppTheme.kWhite,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            body: ChangeNotifierProvider.value(value: homeViewModel, child: const HomeScreenContent()),
          ),
        ),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
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
            itemBuilder: (BuildContext context, int index) {
              final map = {0: chooseFormatScreen, 1: describeScreen, 2: priceScreen, 3: publishScreen};

              return map[index]?.call() ?? const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget chooseFormatScreen() {
    return const ChooseFormatScreen();
  }

  Widget describeScreen() {
    return const DescribeScreen();
  }

  Widget priceScreen() {
    return const PriceScreen();
  }

  Widget publishScreen() {
    return const PublishedNewScreen();
  }
}
