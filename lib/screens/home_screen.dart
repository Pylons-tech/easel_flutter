import 'dart:async';

import 'package:easel_flutter/screens/description_screen.dart';
import 'package:easel_flutter/screens/mint_screen.dart';
import 'package:easel_flutter/screens/publish_screen.dart';
import 'package:easel_flutter/screens/upload_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/screen_size_util.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:flutter/material.dart';
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

  final int _numPages = 4;
  final PageController _pageController = PageController(keepPage: true);
  int _currentPage = 0;

  List title = ["Upload", "Description", "Mint", "Publish"];

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const VerticalSpace(20),
            StepsIndicator(
              selectedStep: _currentPage,
              nbSteps: _numPages,
              lineLength: screenSize.width(percent: 90) / _numPages,
              doneLineColor: Colors.grey,
              undoneLineColor: Colors.grey,
              doneLineThickness: 1.5,
              undoneLineThickness: 1.5,
              unselectedStepColorIn: Colors.grey,
              unselectedStepColorOut: Colors.grey,
              doneStepColor: Colors.grey,
              selectedStepColorIn: kBlue,
              selectedStepColorOut: kBlue,
              enableLineAnimation: false,
              enableStepAnimation: false,
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
                    _currentPage != 3
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _currentPage =
                                        _currentPage > 0 ? _currentPage - 1 : 0;
                                  });

                                  _pageController.jumpToPage(_currentPage);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xFF8D8C8C),
                                )),
                          )
                        : const SizedBox.shrink(),
                    _currentPage == 2
                        ? Text(
                            "Preview NFT",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 16),
                          )
                        : const SizedBox.shrink(),
                    _currentPage == 3
                        ? Row(
                            children: [
                              Text(
                                "Mint more",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 20,
                                        color: const Color(0xFF1212C4),
                                        fontWeight: FontWeight.w400),
                              ),
                              IconButton(
                                padding: EdgeInsets.all(0),
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF1212C4),
                                    size: 18,
                                  )),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            const VerticalSpace(6),
            Expanded(
              child: PageView(
                // allowImplicitScrolling: false,
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
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
    );
  }

  Row _buildTitles(ScreenSizeUtil screenSize) {
    return Row(
      children: List.generate(title.length, (index) {
        return SizedBox(
          width: screenSize.width(percent: 25),
          child: _buildStepTitle(index),
        );
      }),
    );
  }

  Widget _buildStepTitle(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title[index],
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: _currentPage == index ? Colors.black : Colors.grey),
        ),
      ],
    );
  }
}
