import 'dart:async';

import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_list_tile.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/painters/painter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
                style: EaselAppTheme.digitTextStyle,
              )
            ],
          ),
        ));
  }

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
                      Text("creator_hub".tr(), style: EaselAppTheme.titleStyle),
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
    return Column(
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
                    style: EaselAppTheme.titleStyle.copyWith(fontSize: 15.sp),
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
                  child: SizedBox(height: 20.h, width: 20.w, child: Icon(viewModel.publishCollapse ? Icons.add : Icons.remove)),
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
        viewModel.publishCollapse ? const SizedBox() : _buildPublishedNFTsListView(viewModel: viewModel),
      ],
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
                                style: EaselAppTheme.titleStyle.copyWith(fontSize: 15.sp),
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

  Widget _buildPublishedNFTsListView({required CreatorHubViewModel viewModel}) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: viewModel.publishedNFTsList.length,
        itemBuilder: (context, index) {
          final nft = viewModel.publishedNFTsList[index];
          return NFTsListTile(publishedNFT: nft);
        });
  }
}
