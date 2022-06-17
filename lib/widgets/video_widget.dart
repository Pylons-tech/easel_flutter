import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/screens/clippers/custom_triangle_clipper.dart';
import 'package:easel_flutter/screens/clippers/small_bottom_corner_clipper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:easel_flutter/widgets/video_builder.dart';
import 'package:easel_flutter/widgets/video_progress_widget.dart';
import 'package:easel_flutter/widgets/video_widget_full_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import '../screens/custom_widgets/step_labels.dart';
import '../screens/custom_widgets/steps_indicator.dart';

class VideoWidget extends StatefulWidget {
  final File file;
  final bool previewFlag;

  const VideoWidget({Key? key, required this.file, required this.previewFlag}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  EaselProvider get easelProvider => GetIt.I.get();

  final ValueNotifier<int> _currentStep = ValueNotifier(0);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  void initState() {
    scheduleMicrotask(() {
      easelProvider.initializeVideoPlayer();
    });
    super.initState();
  }

  void videoThumbnailPicked() async {
    final result = await FileUtils.pickFile(NftFormat.supportedFormats[0]);
    if (result != null) {
      final loading = Loading().showLoading(message: kCompressingMessage);
      final file = await FileUtils.compressAndGetFile(File(result.path!));
      easelProvider.setVideoThumbnail(file);
      loading.dismiss();
    }
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
              videoThumbnailPicked();
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

  Widget _buildVideoFullScreenIcon() {
    return Positioned(
      right: -1,
      bottom: 0,
      child: ClipPath(
        clipper: CustomTriangleClipper(),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoWidgetFullScreen(
                        file: widget.file,
                        easelProvider: easelProvider,
                      )),
            );
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

  bool shouldShowThumbnailButtonOrStepsOrNot() {
    return !widget.previewFlag;
  }

  stopVideoIfPlaying() {
    if (easelProvider.videoPlayerController.value.isPlaying) {
      easelProvider.videoPlayerController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EaselProvider>.value(
        value: easelProvider,
        child: WillPopScope(
          onWillPop: () async {
            stopVideoIfPlaying();
            easelProvider.setVideoThumbnail(null);
            Navigator.pop(context);
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top + 20.h),
                if (shouldShowThumbnailButtonOrStepsOrNot()) ...[
                  MyStepsIndicator(currentPage: _currentPage, currentStep: _currentStep),
                  VerticalSpace(5.h),
                  StepLabels(currentPage: _currentPage, currentStep: _currentStep),
                  VerticalSpace(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          stopVideoIfPlaying();
                          easelProvider.setVideoThumbnail(null);
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: EaselAppTheme.kBlack,
                        ),
                      ),
                      Text(
                        kPreviewYourNFTText,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: EaselAppTheme.kDarkText,
                            ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
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
                  child: VideoProgressWidget(
                    darkMode: false,
                  ),
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
