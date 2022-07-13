import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/clippers/bottom_sheet_clipper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BuildPublishedNFTsBottomSheet {
  final BuildContext context;
  final NFT nft;
  final EaselProvider easelProvider;

  BuildPublishedNFTsBottomSheet({required this.context, required this.nft, required this.easelProvider});

  Widget moreOptionTile({required String title, required String svg, required VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: () => onPressed(),
        child: Row(
          children: [SvgPicture.asset(svg), SizedBox(width: 30.w), Text(title.tr(), style: EaselAppTheme.titleStyle.copyWith(fontSize: isTablet? 13.sp :16.sp))],
        ),
      ),
    );
  }

  void navigateToPreviewScreen({required BuildContext context, required NFT nft}) {
    easelProvider.setPublishedNFTClicked(nft);
    easelProvider.setPublishedNFTDuration(nft.duration);
    Navigator.of(context).pushReplacementNamed(RouteUtil.kRoutePreviewNFTFullScreen);
  }

  void onViewOnPylonsPressed({required NFT nft}) async {
    String url = easelProvider.fileUtilsHelper.generateEaselLink(
      cookbookId: nft.cookbookID,
      recipeId: nft.recipeID,
    );

    await easelProvider.fileUtilsHelper.launchMyUrl(url: url);
  }

  Future show() {
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
                      title: "view".tr(),
                      svg: kSvgViewIcon),
                  Divider(thickness: 1.h),
                  moreOptionTile(
                      onPressed: () {
                        onViewOnPylonsPressed(nft: nft);
                      },
                      title: "view_on_pylons".tr(),
                      svg: kSvgPylonsLogo),
                ],
              ),
            ),
          );
        });
  }
}
