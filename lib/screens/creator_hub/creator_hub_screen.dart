import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/drafts_more_bottomsheet.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_grid_view.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_list_tile.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../utils/dependency_injection/dependency_injection_container.dart';

class CreatorHubScreen extends StatefulWidget {
  const CreatorHubScreen({Key? key}) : super(key: key);

  @override
  State<CreatorHubScreen> createState() => _CreatorHubScreenState();
}

class _CreatorHubScreenState extends State<CreatorHubScreen> {
  CreatorHubViewModel get creatorHubViewModel => sl();

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      creatorHubViewModel.getPublishAndDraftData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EaselAppTheme.kWhite,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: EaselAppTheme.kBgWhite,
          body: ChangeNotifierProvider.value(
            value: creatorHubViewModel,
            child: FocusDetector(
                onFocusGained: () {
                  GetIt.I.get<CreatorHubViewModel>().getDraftsList();
                },
                child: const CreatorHubContent()),
          ),
        ),
      ),
    );
  }
}

class CreatorHubContent extends StatefulWidget {
  const CreatorHubContent({Key? key}) : super(key: key);

  @override
  State<CreatorHubContent> createState() => _CreatorHubContentState();
}

class _CreatorHubContentState extends State<CreatorHubContent> {
  TextStyle headingStyle = TextStyle(
    fontSize: isTablet ? 20.sp : 25.sp,
    fontWeight: FontWeight.w800,
    color: EaselAppTheme.kBlack,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle titleStyle = TextStyle(
    fontSize: isTablet ? 14.sp : 18.sp,
    fontWeight: FontWeight.w700,
    color: EaselAppTheme.kBlack,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle digitTextStyle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w800,
    color: EaselAppTheme.kWhite,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle subTextStyle = TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w700, fontFamily: kUniversalFontFamily, fontSize:isTablet? 9.sp: 11.sp);
  EaselProvider get easelProvider=> sl();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, CreatorHubViewModel viewModel, child) {
      return Container(
          color: EaselAppTheme.kWhite,
          child: SafeArea(
              child: Scaffold(
            backgroundColor: EaselAppTheme.kBgWhite,
            body: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RouteUtil.kRouteHome,
                          );
                        },
                        child: Container(
                          decoration:  BoxDecoration(color: EaselAppTheme.kpurpleDark,
                          boxShadow: [BoxShadow(color: EaselAppTheme.kpurpleDark.withOpacity(0.6),offset: const Offset(0, 0),
                              blurRadius: 8.0)]),
                          child: Icon(
                            Icons.add,
                            size: 30.h,
                            color: EaselAppTheme.kWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: RichText(
                      text: TextSpan(
                          text: "hello".tr(),
                          style: headingStyle.copyWith(
                            color: EaselAppTheme.kTextGrey,
                          ),
                          children: [TextSpan(text: "${easelProvider.currentUsername}!", style: headingStyle)]),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      "welcome_msg".tr(),
                      style: titleStyle.copyWith(color: EaselAppTheme.kTextGrey, fontSize:isTablet? 12.sp: 15.sp),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        viewModel.selectedCollectionType == CollectionType.draft
                            ? buildSelectedBox(title: "draft", viewModel: viewModel, color: EaselAppTheme.kLightRed, collectionType: CollectionType.draft)
                            : buildOutlinedBox(title: "draft", viewModel: viewModel, collectionType: CollectionType.draft),
                        SizedBox(width: 16.w),
                        viewModel.selectedCollectionType == CollectionType.published
                            ? buildSelectedBox(title: "published", viewModel: viewModel, color: EaselAppTheme.kDarkGreen, collectionType: CollectionType.published)
                            : buildOutlinedBox(title: "published", viewModel: viewModel, collectionType: CollectionType.published),
                        SizedBox(width: 16.w),
                        viewModel.selectedCollectionType == CollectionType.forSale
                            ? buildSelectedBox(title: "for_sale", viewModel: viewModel, color: EaselAppTheme.kBlue, collectionType: CollectionType.forSale)
                            : buildOutlinedBox(title: "for_sale", viewModel: viewModel, collectionType: CollectionType.forSale),
                        SizedBox(width: 16.w),
                        InkWell(
                            onTap: () => viewModel.updateViewType(ViewType.viewGrid),
                            child: SvgPicture.asset(
                              kGridIcon,
                              color: viewModel.viewType == ViewType.viewGrid ? EaselAppTheme.kBlack : EaselAppTheme.kGreyIcon,
                            )),
                        SizedBox(width: 12.w),
                        InkWell(
                          onTap: () => viewModel.updateViewType(ViewType.viewList),
                          child: SvgPicture.asset(kListIcon, color: viewModel.viewType == ViewType.viewList ? EaselAppTheme.kBlack : EaselAppTheme.kGreyIcon),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  viewModel.nftList.isNotEmpty?
                  Expanded(
                      child: viewModel.viewType == ViewType.viewList
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: viewModel.nftList.length,
                                  itemBuilder: (context, index) {
                                    final nft = viewModel.nftList[index];
                                    return viewModel.selectedCollectionType == CollectionType.draft ? buildListTile(nft:nft, viewModel: viewModel) : NFTsListTile(publishedNFT: nft);
                                  }),
                            )
                          : GridView.builder(
                              itemCount: viewModel.nftList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.5,
                                crossAxisSpacing: 15.w,
                                mainAxisSpacing: 15.h,
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (context, index) {
                                final nft = viewModel.nftList[index];
                                return NftGridViewItem(nft: nft);
                              })):
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text("no_nft_created".tr(), style: TextStyle(fontWeight: FontWeight.w700, color: EaselAppTheme.kLightGrey, fontSize:isTablet? 12.sp: 15.sp),),
                      )
                ],
              ),
            ),
          )));
    });
  }

  Widget buildOutlinedBox({required String title, required CreatorHubViewModel viewModel, required CollectionType collectionType}) {
    return Expanded(
      child: InkWell(
        onTap: () => viewModel.changeSelectedCollection(collectionType),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2.sp),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Center(
              child: Text(title.tr(), style: subTextStyle.copyWith(color: EaselAppTheme.kBlack)),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectedBox({required String title, required CreatorHubViewModel viewModel, required Color color, required CollectionType collectionType}) {
    return Expanded(
      child: InkWell(
        onTap: () => viewModel.changeSelectedCollection(collectionType),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 2.sp, color: color), color: color),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Center(
              child: Text(title.tr(), style: subTextStyle.copyWith(color: EaselAppTheme.kWhite)),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile({required NFT nft, required CreatorHubViewModel viewModel}) {
    return Slidable(
      key: ValueKey(nft.id),
      closeOnScroll: false,
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                viewModel.deleteNft(nft.id);
              },
              child: SvgPicture.asset(kSvgDelete),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                viewModel.saveNFT(nft: nft);
                Navigator.of(context).pushNamed(RouteUtil.kRouteHome);
              },
              child: SvgPicture.asset(kSvgPublish),
            ),
          )
        ],
      ),
      child: Container(
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
                  height: 45.h,
                  width: 45.h,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: nft.assetType == kImageText ? nft.url : nft.thumbnailUrl,
                    errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
                    placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "nft_name".tr(args: [nft.name.isNotEmpty ? nft.name : 'Nft Name']),
                        style: titleStyle.copyWith(fontSize: isTablet ? 13.sp : 18.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.h),
                          color: EaselAppTheme.kLightRed,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                        child: Text(
                          "draft".tr(),
                          style: EaselAppTheme.titleStyle.copyWith(color: EaselAppTheme.kWhite, fontSize: isTablet ? 8.sp : 11.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                    onTap: () {
                      final DraftsBottomSheet draftsBottomSheet = DraftsBottomSheet(
                        buildContext: context,
                        nft: nft,
                      );
                      draftsBottomSheet.show();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.0.w),
                      child: SvgPicture.asset(kSvgMoreOption),
                    ))
              ],
            ),
          )),
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final point1 = Offset(-0.5, size.height - 1);
    final point2 = Offset(size.width, 0);
    final paint = Paint()
      ..color = EaselAppTheme.kBlack
      ..strokeWidth = 2;
    canvas.drawLine(point1, point2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
