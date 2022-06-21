import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/video_placeholder.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/clippers/bottom_sheet_clipper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NFTsListTile extends StatelessWidget {
  final NFT publishedNFT;

  const NFTsListTile({Key? key, required this.publishedNFT}) : super(key: key);

  EaselProvider get _easelProvider => GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
        decoration: BoxDecoration(color: EaselAppTheme.kWhite, boxShadow: [
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
                  height: 35.w,
                  width: 35.w,
                  child: LeadingBuilder(
                    onImage: (context) => CachedNetworkImage(
                      errorWidget: (context, url, error) => Align(
                        child: SvgPicture.asset(
                          kSvgNftFormatImage,
                          color: EaselAppTheme.kBlack,
                        ),
                      ),
                      placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
                      imageUrl: publishedNFT.url,
                      fit: BoxFit.cover,
                    ),
                    onVideo: (context) => VideoPlaceHolder(nftUrl: publishedNFT.url, nftName: publishedNFT.name, thumbnailUrl: publishedNFT.thumbnailUrl),
                    onAudio: (context) => SvgPicture.asset(
                      kSvgNftFormatAudio,
                      color: EaselAppTheme.kBlack,
                    ),
                    on3D: (context) => SvgPicture.asset(
                      kSvgNftFormat3d,
                      color: EaselAppTheme.kBlack,
                    ),
                    assetType: publishedNFT.assetType,
                  )),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publishedNFT.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: EaselAppTheme.titleStyle.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "publish".tr(),
                      style: EaselAppTheme.titleStyle.copyWith(color: EaselAppTheme.kDarkGreen, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              InkWell(
                onTap: () => _buildPublishedBottomSheet(context: context, nft: publishedNFT),
                child: SizedBox(
                  height: 25.w,
                  width: 25.w,
                  child: SvgPicture.asset(kSvgMoreOption),
                ),
              )
            ],
          ),
        ));
  }

  navigateToPreviewScreen({required BuildContext context, required NFT nft}) {
    _easelProvider.setPublishedNFTClicked(nft);
    Navigator.of(context).pushReplacementNamed(RouteUtil.ROUTE_PREVIEW_NFT_FULL_SCREEN);
  }

  onViewOnPylonsPressed({required NFT nft}) async {
    String url = FileUtils.generateEaselLink(
      cookbookId: nft.cookbookID,
      recipeId: nft.recipeID,
    );

    await FileUtils.launchMyUrl(url: url);
  }

  Widget moreOptionTile({required String title, required String svg, required Function onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Row(
          children: [SvgPicture.asset(svg), SizedBox(width: 30.w), Text(title.tr(), style: EaselAppTheme.titleStyle.copyWith(fontSize: 16.sp))],
        ),
      ),
    );
  }

  _buildPublishedBottomSheet({required BuildContext context, required NFT nft}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return ClipPath(
            clipper: BottomSheetClipper(),
            child: Container(
              color: EaselAppTheme.kBgColor,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
              child: Wrap(
                children: [
                  moreOptionTile(
                      onPressed: () {
                        navigateToPreviewScreen(context: context, nft: nft);
                      },
                      title: kViewOnIPFS,
                      svg: kSvgViewIcon),
                  Divider(thickness: 1.h),
                  moreOptionTile(
                      onPressed: () {
                        onViewOnPylonsPressed(nft: nft);
                      },
                      title: kViewOnPylons,
                      svg: kSvgPylonsLogo),
                ],
              ),
            ),
          );
        });
  }
}

class LeadingBuilder extends StatelessWidget {
  final WidgetBuilder onImage;
  final WidgetBuilder onVideo;
  final WidgetBuilder onAudio;
  final WidgetBuilder on3D;
  final AssetType assetType;

  const LeadingBuilder({
    Key? key,
    required this.onImage,
    required this.onVideo,
    required this.onAudio,
    required this.on3D,
    required this.assetType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (assetType) {
      case AssetType.Audio:
        return onAudio(context);
      case AssetType.Image:
        return onImage(context);
      case AssetType.Video:
        return onVideo(context);
    }
  }
}
