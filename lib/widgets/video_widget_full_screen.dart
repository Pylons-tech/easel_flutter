import 'dart:io';
import 'dart:ui';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/widgets/video_progress_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoWidgetFullScreen extends StatelessWidget {
  final File file;
  final EaselProvider easelProvider;

  const VideoWidgetFullScreen({Key? key, required this.file, required this.easelProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EaselAppTheme.kBlack,
      child: ChangeNotifierProvider<EaselProvider>.value(
        value: easelProvider,
        child: Stack(
          children: [
            easelProvider.isVideoLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(EaselAppTheme.kWhite),
                    ),
                  )
                : easelProvider.videoLoadingError.isNotEmpty
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: Text(
                          videoPlayerError,
                          style: TextStyle(fontSize: 18.sp, color: EaselAppTheme.kWhite),
                        ),
                      ))
                    : easelProvider.videoPlayerController.value.isInitialized
                        ? Center(
                            child: AspectRatio(
                              aspectRatio: easelProvider.videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(easelProvider.videoPlayerController),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(EaselAppTheme.kWhite),
                            ),
                          ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                        padding: EdgeInsets.only(bottom: 30.h),

                        ///Don't place const here, it will stop reflecting changes
                        child: VideoProgressWidget(darkMode: true),
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
