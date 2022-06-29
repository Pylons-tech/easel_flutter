import 'dart:developer';

import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../services/datasources/local_datasource.dart';
import '../../../utils/enums.dart';
import '../../../widgets/clippers/bottom_sheet_clipper.dart';
import '../creator_hub_view_model.dart';

class DraftsBottomSheet {
  final BuildContext buildContext;
  final NFT nft;
  final LocalDataSource localDataSource;

  DraftsBottomSheet({required this.buildContext, required this.nft, required this.localDataSource});

  void show() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: buildContext,
        builder: (BuildContext bc) {
          return DraftsMoreBottomSheet(
            nft: nft,
            localDataSource: localDataSource,
          );
        });
  }
}

class DraftsMoreBottomSheet extends StatelessWidget {
  const DraftsMoreBottomSheet({Key? key, required this.nft, required this.localDataSource}) : super(key: key);

  final NFT nft;
  final LocalDataSource localDataSource;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreatorHubViewModel>();
    return ClipPath(
      clipper: BottomSheetClipper(),
      child: Container(
        color: EaselAppTheme.kLightGrey02,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: Wrap(
          children: [
            moreOptionTile(
                title: "publish",
                svg: kSvgPublish,
                onPressed: () {
                  localDataSource.setCacheDynamicType(key: "nft", value: nft);
                  localDataSource.setCacheString(key: "from", value: "draft");
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(RouteUtil.ROUTE_HOME);
                }),
            const Divider(
              color: EaselAppTheme.kGrey,
            ),
            moreOptionTile(
                title: "delete",
                svg: kSvgDelete,
                onPressed: () {
                  Navigator.of(context).pop();
                  viewModel.deleteNft(nft.id);
                }),
            const Divider(
              color: EaselAppTheme.kGrey,
            ),
            moreOptionTile(title: "view", svg: kSvgView, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

Widget moreOptionTile({required String title, required String svg, required Function onPressed}) {
  TextStyle titleStyle = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, fontFamily: kUniversalFontFamily, color: EaselAppTheme.kBlack);

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: InkWell(
      onTap: () {
        onPressed();
      },
      child: Row(
        children: [
          SvgPicture.asset(svg),
          SizedBox(
            width: 30.w,
          ),
          Text(
            title.tr(),
            style: titleStyle.copyWith(fontSize: 16.sp),
          )
        ],
      ),
    ),
  );
}
