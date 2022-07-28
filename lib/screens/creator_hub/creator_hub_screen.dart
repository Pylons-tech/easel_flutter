import 'dart:async';
import 'dart:developer';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/draft_list_tile.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_grid_view.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/delete_confirmation_dialog.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/drafts_more_bottomsheet.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_list_tile.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/painters/painter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../utils/dependency_injection/dependency_injection_container.dart';

class CreatorHubScreen extends StatefulWidget {
  const CreatorHubScreen({Key? key}) : super(key: key);

  @override
  State<CreatorHubScreen> createState() => _CreatorHubScreenState();
}

class _CreatorHubScreenState extends State<CreatorHubScreen> {
  CreatorHubViewModel get creatorHubViewModel => sl();

  EaselProvider get easelProvider => sl();

  @override
  void initState() {
    easelProvider.populateUserName();
    scheduleMicrotask(() {
      creatorHubViewModel.getPublishAndDraftData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EaselAppTheme.kBgWhite,
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
  TextStyle subTextStyle = TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w700, fontFamily: kUniversalFontFamily, fontSize: isTablet ? 9.sp : 11.sp);

  EaselProvider get easelProvider => sl();

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
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: IconButton(
                              onPressed: () => scheduleMicrotask(() {
                                    viewModel.getRecipesList();
                                  }),
                              icon: Icon(Icons.refresh, color: EaselAppTheme.kBlack, size: 20.h)),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pushNamed(RouteUtil.kRouteHome),
                          child: Container(
                            decoration:
                                BoxDecoration(color: EaselAppTheme.kpurpleDark, boxShadow: [BoxShadow(color: EaselAppTheme.kpurpleDark.withOpacity(0.6), offset: const Offset(0, 0), blurRadius: 8.0)]),
                            child: Icon(Icons.add, size: 27.h, color: EaselAppTheme.kWhite),
                          ),
                        ),
                      ],
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
                      style: titleStyle.copyWith(color: EaselAppTheme.kTextGrey, fontSize: isTablet ? 12.sp : 15.sp),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        viewModel.selectedCollectionType == CollectionType.draft
                            ? buildSelectedBox(title: "draft".tr(), viewModel: viewModel, color: EaselAppTheme.kLightRed, collectionType: CollectionType.draft)
                            : buildOutlinedBox(title: "draft".tr(), viewModel: viewModel, collectionType: CollectionType.draft),
                        SizedBox(width: 14.w),
                        viewModel.selectedCollectionType == CollectionType.published
                            ? buildSelectedBox(title: "published".tr(), viewModel: viewModel, color: EaselAppTheme.kDarkGreen, collectionType: CollectionType.published)
                            : buildOutlinedBox(title: "published".tr(), viewModel: viewModel, collectionType: CollectionType.published),
                        SizedBox(width: 14.w),
                        viewModel.selectedCollectionType == CollectionType.forSale
                            ? buildSelectedBox(title: "for_sale".tr(), viewModel: viewModel, color: EaselAppTheme.kBlue, collectionType: CollectionType.forSale)
                            : buildOutlinedBox(title: "for_sale".tr(), viewModel: viewModel, collectionType: CollectionType.forSale),
                        SizedBox(width: 16.w),
                        InkWell(
                            onTap: () => viewModel.updateViewType(ViewType.viewGrid),
                            child: SvgPicture.asset(kGridIcon, height: 15.h, color: viewModel.viewType == ViewType.viewGrid ? EaselAppTheme.kBlack : EaselAppTheme.kGreyIcon)),
                        SizedBox(width: 14.w),
                        InkWell(
                          onTap: () => viewModel.updateViewType(ViewType.viewList),
                          child: SvgPicture.asset(kListIcon, height: 15.h, color: viewModel.viewType == ViewType.viewList ? EaselAppTheme.kBlack : EaselAppTheme.kGreyIcon),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  viewModel.nftList.isNotEmpty
                      ? Expanded(
                          child: viewModel.viewType == ViewType.viewList
                              ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: viewModel.nftList.length,
                                      itemBuilder: (context, index) {
                                        final nft = viewModel.nftList[index];
                                        return viewModel.selectedCollectionType == CollectionType.draft ? DraftListTile(nft: nft, viewModel: viewModel) : NFTsListTile(publishedNFT: nft);
                                      }),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: GridView.builder(
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
                                      }),
                                ))
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            "no_nft_created".tr(),
                            style: TextStyle(fontWeight: FontWeight.w700, color: EaselAppTheme.kLightGrey, fontSize: isTablet ? 12.sp : 15.sp),
                          ),
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
              child: Text(title, style: subTextStyle.copyWith(color: EaselAppTheme.kBlack)),
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
              child: Text(title, style: subTextStyle.copyWith(color: EaselAppTheme.kWhite)),
            ),
          ),
        ),
      ),
    );
  }
}
