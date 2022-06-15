import 'dart:async';
import 'dart:io';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/screens/clippers/custom_triangle_clipper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:easel_flutter/utils/space_utils.dart';
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
      easelProvider.setVideoThumbnail(File(result.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EaselProvider>.value(
        value: easelProvider,
        child: WillPopScope(
          onWillPop: () async {
            easelProvider.setVideoThumbnail(null);
            Navigator.pop(context);
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top + 20.h),
                if (!widget.previewFlag) ...[
                  MyStepsIndicator(currentPage: _currentPage, currentStep: _currentStep),
                  VerticalSpace(5.h),
                  StepLabels(currentPage: _currentPage, currentStep: _currentStep),
                  VerticalSpace(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
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
                      ClipPath(
                        // clipper: RightSmallBottomClipper(),
                        child: SizedBox(
                          height: 200.h,
                          child: Stack(
                            children: [
                              easelProvider.isVideoLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(EaselAppTheme.kBlack),
                                      ),
                                    )
                                  : easelProvider.videoLoadingError.isNotEmpty
                                      ? Center(
                                          child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            videoPlayerError,
                                            style: TextStyle(fontSize: 18.sp, color: EaselAppTheme.kBlack),
                                          ),
                                        ))
                                      : easelProvider.videoPlayerController.value.isInitialized
                                          ? Center(
                                              child: Stack(
                                                children: [
                                                  AspectRatio(
                                                    aspectRatio: easelProvider.videoPlayerController.value.aspectRatio,
                                                    child: VideoPlayer(easelProvider.videoPlayerController),
                                                  ),
                                                  Positioned(
                                                    right: 0,
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
                                                          width: 45.w,
                                                          height: 35.h,
                                                          color: EaselAppTheme.kLightRed,
                                                          child: Padding(
                                                            padding: EdgeInsets.fromLTRB(25.w, 18.w, 3.w, 3.h),
                                                            child: SvgPicture.asset(
                                                              kFullScreenIcon,
                                                              fit: BoxFit.fill,
                                                              alignment: Alignment.bottomRight,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(EaselAppTheme.kBlack),
                                              ),
                                            ),
                            ],
                          ),
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

                  ///Don't place const here, it will stop reflecting changes
                  child: VideoProgressWidget(darkMode: false),
                ),
                if (!widget.previewFlag) ...[
                  Align(
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
                              ? Container(
                                  height: 60.h,
                                  width: 60.w,
                                  margin: EdgeInsets.only(left: 10.w),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: ExactAssetImage(kVideoThumbnailRectangle),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(13.h),
                                    child: Image.file(
                                      easelProvider.videoThumbnail!,
                                      height: 60.h,
                                      width: 60.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ))
                              : SvgPicture.asset(kUploadThumbnail),
                        ),
                      ),
                    ),
                  ),
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
