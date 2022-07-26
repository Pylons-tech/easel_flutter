import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/delete_confirmation_dialog.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/drafts_more_bottomsheet.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_list_tile.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/painters/painter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_it/get_it.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
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
  TextStyle titleStyle = TextStyle(
    fontSize: isTablet ? 14.sp : 18.sp,
    fontWeight: FontWeight.w800,
    color: EaselAppTheme.kBlack,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle digitTextStyle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w800,
    color: EaselAppTheme.kWhite,
    fontFamily: kUniversalFontFamily,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, CreatorHubViewModel viewModel, child) {
      return Padding(
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
                      Navigator.of(context).pushNamed(
                        RouteUtil.kRouteHome,
                      );
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
                Expanded(child: buildCard(title: "for_sale".tr(), count: viewModel.forSaleCount.toString(), cardColor: EaselAppTheme.kBlue, viewModel: viewModel)),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(child: buildCard(title: "published".tr(), count: viewModel.publishedRecipesLength.toString(), cardColor: EaselAppTheme.kDarkGreen, viewModel: viewModel)),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(child: buildCard(title: "draft".tr(), count: viewModel.nftList.length.toString(), cardColor: EaselAppTheme.kLightRed, viewModel: viewModel))
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                primary: false,
                children: [
                  SizedBox(height: 10.h),
                  publishedNFTsContainer(title: "publish_total".tr(args: [viewModel.publishedRecipesLength.toString()]), viewModel: viewModel),
                  SizedBox(height: 20.h),
                  draftNFTsContainer(title: "draft_total".tr(args: [viewModel.nftList.length.toString()]), viewModel: viewModel)
                ],
              ),
            ),
          ],
        ),
      );
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
                  height: isTablet ? 30.h : 23.h,
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
                  child: SizedBox(
                      height: isTablet ? 30.h : 20.h,
                      width: isTablet ? 30.w : 20.w,
                      child: Icon(
                        viewModel.publishCollapse ? Icons.add : Icons.remove,
                        size: isTablet ? 15.w : 20.w,
                      )),
                ),
                IconButton(
                    onPressed: () => scheduleMicrotask(() {
                          viewModel.getPublishAndDraftData();
                        }),
                    icon: Icon(
                      Icons.refresh,
                      color: EaselAppTheme.kBlack,
                      size: 18.h,
                    ))
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
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 120.w,
                  height: isTablet ? 30.h : 23.h,
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
                  child: SizedBox(
                      height: isTablet ? 30.h : 20.h,
                      width: isTablet ? 30.w : 20.w,
                      child: Icon(
                        viewModel.draftCollapse ? Icons.add : Icons.remove,
                        size: isTablet ? 15.w : 20.w,
                      )),
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
        viewModel.draftCollapse
            ? const SizedBox()
            : viewModel.nftList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) => DraftsListTile(
                      nft: viewModel.nftList[index],
                    ),
                    itemCount: viewModel.nftList.length,
                  )
                : const SizedBox()
      ],
    );
  }

  Widget _buildPublishedNFTsListView({required CreatorHubViewModel viewModel}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: viewModel.publishedNFTsList.length,
        itemBuilder: (context, index) {
          final nft = viewModel.publishedNFTsList[index];
          return NFTsListTile(publishedNFT: nft);
        });
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
                style: TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w400, fontFamily: kUniversalFontFamily, fontSize: 12.sp),
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

class DraftsListTile extends StatefulWidget {
  final NFT nft;

  const DraftsListTile({Key? key, required this.nft}) : super(key: key);

  @override
  State<DraftsListTile> createState() => _DraftsListTileState();
}

class _DraftsListTileState extends State<DraftsListTile> {
  TextStyle titleStyle = TextStyle(
    fontSize: isTablet ? 14.sp : 18.sp,
    fontWeight: FontWeight.w800,
    color: EaselAppTheme.kBlack,
    fontFamily: kUniversalFontFamily,
  );

  Widget threeDWidget = const SizedBox();

  @override
  void initState() {
    super.initState();

    if (widget.nft.assetType.toAssetTypeEnum() == AssetType.ThreeD) {
      threeDWidget = ModelViewer(
        src: widget.nft.url,
        ar: false,
        autoRotate: false,
        cameraControls: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CreatorHubViewModel>();
    return Slidable(
      key: ValueKey(widget.nft.id),
      closeOnScroll: false,
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                final DeleteDialog deleteDialog = DeleteDialog(contextt: context, nft: widget.nft);
                deleteDialog.show();
              },
              child: SvgPicture.asset(kSvgDelete),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                viewModel.saveNFT(nft: widget.nft);
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
                    child: LeadingBuilder(
                        onImage: (_) => CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: widget.nft.url,
                              errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
                              placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
                            ),
                        onVideo: (_) => CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: widget.nft.thumbnailUrl,
                              errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
                              placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
                            ),
                        onAudio: (_) => CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: widget.nft.thumbnailUrl,
                              errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
                              placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
                            ),
                        on3D: (_) => threeDWidget,
                        assetType: widget.nft.assetType.toAssetTypeEnum())),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "nft_name".tr(args: [widget.nft.name.isNotEmpty ? widget.nft.name : 'Nft Name']),
                        style: titleStyle.copyWith(fontSize: isTablet ? 13.sp : 18.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        "draft".tr(),
                        style: titleStyle.copyWith(color: EaselAppTheme.kLightRed, fontSize: isTablet ? 8.sp : 13.sp),
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
                        nft: widget.nft,
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
