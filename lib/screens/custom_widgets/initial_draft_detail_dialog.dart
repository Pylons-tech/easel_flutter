import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart' as clipper;
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

TextStyle _rowTitleTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: isTablet ? 11.sp : 13.sp);

class DraftDetailDialog {
  final BuildContext context;

  DraftDetailDialog({required this.context});

  Future<void> show() async {
    await showDialog<String>(context: context, barrierDismissible: false, builder: (BuildContext context) => const _DraftDetailDialog());
  }
}

class _DraftDetailDialog extends StatelessWidget {
  const _DraftDetailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EaselProvider easelProvider = context.watch<EaselProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 65.w : 21.w),
      child: Container(
        color: Colors.black.withOpacity(0.7),
        height: isTablet ? 400.h : 340.h,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 60.h,
                width: 60.h,
                child: ClipPath(
                  clipper: RightTriangleClipper(orientation: clipper.Orientation.orientationNW),
                  child: Container(
                    color: EaselAppTheme.kLightRed,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                height: 60.h,
                width: 60.h,
                child: ClipPath(
                  clipper: RightTriangleClipper(orientation: clipper.Orientation.orientationSE),
                  child: Container(
                    color: EaselAppTheme.kLightRed,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100.h,
                    width: 100.h,
                    child:
                    easelProvider.nft.assetType == k3dText
                        ? ModelViewer(
                      src: easelProvider.nft.url,
                      ar: false,
                      autoRotate: false,
                      cameraControls: false,
                    )
                        : CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: getImageUrl(easelProvider),
                      errorWidget: (a, b, c) => const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white,
                          )),
                      placeholder: (context, url) => Shimmer(
                          color: EaselAppTheme.cardBackground,
                          child: SizedBox(
                            height: 100.h,
                            width: 100.h,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  buildRow(
                    title: "upload_to_ipfs".tr(),
                    subtitle: easelProvider.nft.fileName,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  buildRow(
                    title: "content_id".tr(),
                    subtitle: easelProvider.nft.cid,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  buildViewOnIPFS(
                      title: "tx_receipt".tr(),
                      subtitle: "view".tr(),
                      onPressed: () {
                        navigateToPreviewScreen(context: context, nft: easelProvider.nft);
                      }),
                  SizedBox(
                    height: 50.h,
                  ),
                  SizedBox(
                    height: 45.h,
                    width: isTablet ? 120.w : 150.w,
                    child: ClippedButton(
                      title: "close".tr(),
                      bgColor: Colors.white.withOpacity(0.2),
                      textColor: EaselAppTheme.kWhite,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      cuttingHeight: 15.h, clipperType: ClipperType.bottomLeftTopRight,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void navigateToPreviewScreen({required BuildContext context, required NFT nft}) {
    context.read<EaselProvider>().setPublishedNFTClicked(nft);
    context.read<EaselProvider>().setPublishedNFTDuration(nft.duration);
    Navigator.of(context).pushReplacementNamed(RouteUtil.kRoutePreviewNFTFullScreen);
  }

  String getImageUrl(EaselProvider easelProvider) {
    if (easelProvider.nft.assetType == kImageText) {
      return easelProvider.nft.url;
    } else {
      return easelProvider.nft.thumbnailUrl;
    }
  }

  Widget buildRow({required String title, required String subtitle}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: isTablet ? 20.w : 40.w, right: 5.w),
          child: Text(
            title,
            style: _rowTitleTextStyle,
          ),
        )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                  right: 5.w,
                ),
                child: subtitle.length > 14
                    ? Row(
                        children: [
                          Text(
                            subtitle.substring(0, 8),
                            style: _rowTitleTextStyle,
                          ),
                          const Text("...",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          Text(
                            subtitle.substring(subtitle.length - 5, subtitle.length),
                            style: _rowTitleTextStyle,
                          ),
                        ],
                      )
                    : Text(
                        subtitle,
                        style: _rowTitleTextStyle,
                      )))
      ],
    );
  }

  Widget buildViewOnIPFS({required String title, required String subtitle, required Function onPressed}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: isTablet ? 20.w : 40.w, right: 5.w),
          child: Text(
            title,
            style: _rowTitleTextStyle,
          ),
        )),
        Expanded(
          child: InkWell(
            onTap: () {
              onPressed();
            },
            child: Padding(
              padding: EdgeInsets.only(
                right: 5.w,
              ),
              child: Text(
                subtitle,
                style: subtitle == "view".tr() ? _rowTitleTextStyle.copyWith(color: EaselAppTheme.kLightPurple) : _rowTitleTextStyle,
              ),
            ),
          ),
        )
      ],
    );
  }
}
