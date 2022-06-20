import 'dart:async';

import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/painters/painter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatorHubScreen extends StatefulWidget {
  const CreatorHubScreen({Key? key}) : super(key: key);

  @override
  State<CreatorHubScreen> createState() => _CreatorHubScreenState();
}

class _CreatorHubScreenState extends State<CreatorHubScreen> {
  @override
  void initState() {
    scheduleMicrotask(() {
      Provider.of<CreatorHubViewModel>(context, listen: false).getRecipesList();
    });
    super.initState();
  }

  TextStyle titleStyle = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: EaselAppTheme.kBlack);
  TextStyle digitTextStyle = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: EaselAppTheme.kWhite);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, CreatorHubViewModel viewModel, child) {
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
                          onTap: () {
                            Navigator.of(context).pushNamed(RouteUtil.ROUTE_HOME);
                          },
                          child: Icon(
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
                      Expanded(child: buildCard(title: "for_sale".tr(), count: 0.toString(), cardColor: EaselAppTheme.kBlue, viewModel: viewModel)),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(child: buildCard(title: "publish".tr(), count: viewModel.publishedRecipesLength.toString(), cardColor: EaselAppTheme.kDarkGreen, viewModel: viewModel)),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(child: buildCard(title: "draft".tr(), count: 0.toString(), cardColor: EaselAppTheme.kLightRed, viewModel: viewModel))
                    ],
                  ),
                  SizedBox(height: 30.h),
                  publishedNFTsContainer(title: "publish_total".tr(args: [viewModel.publishedRecipesLength.toString()]), viewModel: viewModel),
                  SizedBox(height: 20.h),
                  draftNFTsContainer(title: "draft_total".tr(args: ["0"]), viewModel: viewModel)
                ],
              ),
            ),
          )));
    });
  }

  Widget publishedNFTsContainer({required String title, required CreatorHubViewModel viewModel}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: viewModel.publishCollapse ? 40.h : 130.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
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
                                viewModel.publishCollapse = !viewModel.publishCollapse;
                              },
                              child: SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: Icon(
                                    viewModel.publishCollapse ? Icons.add : Icons.remove,
                                  )),
                            )
                          ],
                        ),
                        Wrap(
                          children: [
                            Container(
                              width: 120.w,
                              height: 10.h,
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: EaselAppTheme.kBlack, width: 2)),
                              ),
                            ),
                            CustomPaint(size: Size(10.w, 10.h), painter: DiagonalLinePainter()),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    viewModel.publishCollapse ? const SizedBox() : _buildPublishedNFTsListView(publishedNFTs: viewModel.publishedNFTsList, viewModel: viewModel),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget draftNFTsContainer({required String title, required CreatorHubViewModel viewModel}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: viewModel.draftCollapse ? 40.h : 150.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
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
                                viewModel.draftCollapse = !viewModel.draftCollapse;
                              },
                              child: SizedBox(height: 20.h, width: 20.w, child: Icon(viewModel.draftCollapse ? Icons.add : Icons.remove)),
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
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    viewModel.draftCollapse ? const SizedBox() : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishedNFTsListView({required List<NFT> publishedNFTs, required CreatorHubViewModel viewModel}) {
    return SizedBox(
      height: viewModel.publishCollapse ? 40.h : 150.h,
      child: ListView.builder(
          itemCount: publishedNFTs.length,
          itemBuilder: (context, index) {
            final nft = publishedNFTs[index];
            return buildListTile(publishedNFT: nft);
          }),
    );
  }

  Widget buildListTile({required NFT publishedNFT}) {
    return  Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            children: [
              SizedBox(
                  height: 45.w,
                  width: 45.w,
                  child: Container(
                    color: Colors.blue,
                  )
                // SvgPicture.asset(
                //   kAlertIcon,
                //   color: EaselAppTheme.kBlack,
                // ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publishedNFT.name,
                      style: titleStyle,
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "publish".tr(),
                      style: titleStyle.copyWith(color: EaselAppTheme.kLightRed, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              SvgPicture.asset(kSvgMoreOption)
            ],
          ),
        )

    );
  }

  Widget buildCard({required String title, required String count, required Color cardColor, required CreatorHubViewModel viewModel}) {
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
                count,
                style: digitTextStyle,
              )
            ],
          ),
        ));
  }
}
