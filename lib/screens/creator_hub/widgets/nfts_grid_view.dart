import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/drafts_more_bottomsheet.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/published_nfts_bottom_sheet.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NftGridViewItem extends StatelessWidget {
  const NftGridViewItem({Key? key, required this.nft}) : super(key: key);
  final NFT nft;
  EaselProvider get _easelProvider => GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          height: 200.h,
          errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),

          placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
          imageUrl:  nft.url,
          fit: BoxFit.fitHeight,
        ),
        Positioned(
          right: 10.w,
          top: 10.h,
          child: InkWell(
              onTap: () {
               if( context.read<CreatorHubViewModel>().selectedCollectionType == CollectionType.draft ){
                 final DraftsBottomSheet draftsBottomSheet = DraftsBottomSheet(
                   buildContext: context,
                   nft: nft,
                 );
                 draftsBottomSheet.show();
                 return;
               }
               buildBottomSheet(context: context);

              },
              child: SvgPicture.asset(kSvgMoreOption, color: EaselAppTheme.kWhite,)),
        )
      ],
    );
  }
  void buildBottomSheet({required BuildContext context}) {
    final bottomSheet = BuildPublishedNFTsBottomSheet(context: context, nft: nft, easelProvider: _easelProvider);

    bottomSheet.show();
  }
}
