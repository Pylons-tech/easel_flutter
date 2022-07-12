import 'dart:async';
import 'dart:ui';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/preview_nft/nft_audio_player_screen.dart';
import 'package:easel_flutter/screens/preview_nft/nft_image_screen.dart';
import 'package:easel_flutter/screens/preview_nft/nft_video_player_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class PreviewNFTFullScreen extends StatefulWidget {
  const PreviewNFTFullScreen({Key? key}) : super(key: key);

  @override
  State<PreviewNFTFullScreen> createState() => _PreviewNFTFullScreenState();
}

class _PreviewNFTFullScreenState extends State<PreviewNFTFullScreen> {
  EaselProvider get easelProvider => GetIt.I.get();

  @override
  void initState() {
    scheduleMicrotask(() {
      easelProvider.initializePlayers(publishedNFT: easelProvider.publishedNFTClicked);
    });
    super.initState();
  }

  onBackPressed({required BuildContext context}) {
    if (easelProvider.publishedNFTClicked.assetType == AssetType.Video.name && easelProvider.videoPlayerController.value.isInitialized) {
      if (easelProvider.videoPlayerController.value.isPlaying) {
        easelProvider.videoPlayerController.pause();
      }
    }
    easelProvider.videoLoadingError = '';

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          onBackPressed(context: context);
          return true;
        },
        child: Stack(
          children: [
            PreviewNFTBuilder(
                onImage: (context) => NftImageWidget(imageUrl: easelProvider.publishedNFTClicked.url),
                onVideo: (context) => const NFTVideoPlayerScreen(),
                onAudio: (context) => const NFTAudioPlayerScreen(),
                on3D: (context) => Container(),
                assetType: easelProvider.publishedNFTClicked.assetType.toAssetTypeEnum()),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 30.h, 0, 10.h),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                onBackPressed(context: context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 22.h,
                                color: EaselAppTheme.kWhite,
                              ),
                            ),
                            Text(
                              kBack,
                              style: EaselAppTheme.titleStyle.copyWith(fontSize: 18.sp, color: EaselAppTheme.kWhite),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PreviewNFTBuilder extends StatelessWidget {
  final WidgetBuilder onImage;
  final WidgetBuilder onVideo;
  final WidgetBuilder onAudio;
  final WidgetBuilder on3D;
  final AssetType assetType;

  const PreviewNFTBuilder({
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
