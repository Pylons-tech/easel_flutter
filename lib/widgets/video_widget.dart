import 'dart:async';
import 'dart:io';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/clippers/custom_triangle_clipper.dart';
import 'package:easel_flutter/screens/clippers/small_bottom_corner_clipper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/video_builder.dart';
import 'package:easel_flutter/widgets/video_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final File? file;
  final String? filePath;
  final bool previewFlag;
  final bool isForFile;

  const VideoWidget({Key? key, this.file, this.filePath, required this.previewFlag, required this.isForFile}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  EaselProvider get easelProvider => GetIt.I.get();




  @override
  void initState() {
    scheduleMicrotask(() {
      if (widget.file != null) {
        easelProvider.initializeVideoPlayerWithFile();
      } else {
        easelProvider.initializeVideoPlayerWithUrl(publishedNftUrl: widget.filePath!);
      }
    });
    super.initState();
  }

  Widget _buildVideoFullScreenIcon() {
    return Positioned(
      right: -1,
      bottom: 0,
      child: ClipPath(
        clipper: CustomTriangleClipper(),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteUtil.kVideoFullScreen);
          },
          child: Container(
            width: 30.w,
            height: 30.w,
            alignment: Alignment.bottomRight,
            color: EaselAppTheme.kLightRed,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: SvgPicture.asset(
                kFullScreenIcon,
                fit: BoxFit.fill,
                width: 8.w,
                height: 8.w,
                alignment: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20.h),
        child: SizedBox(
          height: 120.h,
          width: 120.w,
          child: InkWell(
            onTap: () {
              easelProvider.onVideoThumbnailPicked();
            },
            child: easelProvider.videoThumbnail != null
                ? ClipPath(
                    clipper: RightSmallBottomClipper(),
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        margin: EdgeInsets.only(left: 10.w),
                        child: Image.file(
                          easelProvider.videoThumbnail!,
                          height: 60.h,
                          width: 60.w,
                          fit: BoxFit.fill,
                        )),
                  )
                : SvgPicture.asset(kUploadThumbnail),
          ),
        ),
      ),
    );
  }

  bool shouldShowThumbnailButtonOrStepsOrNot() {
    return !widget.previewFlag;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EaselProvider>.value(
        value: easelProvider,
        child: WillPopScope(
          onWillPop: () async {
            easelProvider.stopVideoIfPlaying();
            easelProvider.setVideoThumbnail(null);
            Navigator.pop(context);
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top + 20.h),
                if (shouldShowThumbnailButtonOrStepsOrNot()) ...[
                  VerticalSpace(50.h),
                ],
                SizedBox(
                  height: 20.w,
                ),
                SizedBox(
                  width: 280.w,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200.h,
                        child: Stack(
                          children: [
                            VideoBuilder(
                                onVideoLoading: (BuildContext context) => const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(EaselAppTheme.kBlack),
                                      ),
                                    ),
                                onVideoHasError: (BuildContext context) => Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        videoPlayerError,
                                        style: TextStyle(fontSize: 18.sp, color: EaselAppTheme.kBlack),
                                      ),
                                    )),
                                onVideoInitialized: (BuildContext context) => Center(
                                      child: Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: easelProvider.videoPlayerController.value.aspectRatio,
                                            child: VideoPlayer(easelProvider.videoPlayerController),
                                          ),
                                          _buildVideoFullScreenIcon(),
                                        ],
                                      ),
                                    ),
                                easelProvider: easelProvider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 70.h),
                  child: VideoProgressWidget(darkMode: true, isForFile: widget.isForFile),
                ),
                if (shouldShowThumbnailButtonOrStepsOrNot()) ...[
                  _buildThumbnailButton(),
                ],
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
