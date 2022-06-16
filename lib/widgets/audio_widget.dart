import 'dart:io';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/widgets/audio_widget_full_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../models/nft_format.dart';
import '../screens/clippers/custom_triangle_clipper.dart';
import '../screens/clippers/small_bottom_corner_clipper.dart';
import '../screens/custom_widgets/step_labels.dart';
import '../screens/custom_widgets/steps_indicator.dart';
import '../utils/easel_app_theme.dart';
import '../utils/file_utils.dart';
import '../utils/space_utils.dart';
import 'loading.dart';

class AudioWidget extends StatefulWidget {
  final File file;
  final bool previewFlag;

  const AudioWidget({Key? key, required this.file, required this.previewFlag}) : super(key: key);

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> with WidgetsBindingObserver {
  EaselProvider get easelProvider => GetIt.I.get();
  final ValueNotifier<int> _currentStep = ValueNotifier(0);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  initState() {
    easelProvider.initializeAudioPlayer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 15.0.h,
          ),
          if (widget.previewFlag) ...[
            MyStepsIndicator(currentPage: _currentPage, currentStep: _currentStep),
            VerticalSpace(5.h),
            StepLabels(currentPage: _currentPage, currentStep: _currentStep),
            VerticalSpace(10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: EaselAppTheme.kBlack,
                  ),
                ),
                Text(
                  kPreviewNftFileText,
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
            height: 50.0.h,
          ),
          Stack(
            children: [
              ClipPath(
                clipper: RightSmallBottomClipper(),
                child: Container(
                  width: 300.0.w,
                  height: 150.0.h,
                  color: Colors.blue,
                  child: easelProvider.audioThumnail != null
                      ? Image.file(
                          easelProvider.audioThumnail!,
                          height: 60.h,
                          width: 60.w,
                          fit: BoxFit.contain,
                        )
                      : const SizedBox(),
                ),
              ),
              _buildAudioFullScreenIcon()
            ],
          ),
          SizedBox(
            height: 30.0.h,
          ),
          SizedBox(
            width: 330.0.w,
            child: Consumer<EaselProvider>(builder: (context, viewModel, _) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.w, bottom: 10.h, top: 10.h, left: 5.w),
                    child: ValueListenableBuilder<ButtonState>(
                      valueListenable: viewModel.buttonNotifier,
                      builder: (_, value, __) {
                        switch (value) {
                          case ButtonState.loading:
                            return SizedBox(height: 22.h, width: 22.h, child: CircularProgressIndicator(strokeWidth: 2.w, color: Colors.black));
                          case ButtonState.paused:
                            return InkWell(
                              onTap: viewModel.playAudio,
                              child: Icon(
                                Icons.play_arrow,
                                color: EaselAppTheme.kDarkBlue,
                                size: 22.h,
                              ),
                            );

                          case ButtonState.playing:
                            return InkWell(
                              onTap: viewModel.pauseAudio,
                              child: Icon(
                                Icons.pause,
                                color: EaselAppTheme.kDarkBlue,
                                size: 22.h,
                              ),
                            );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<ProgressBarState>(
                      valueListenable: viewModel.audioProgressNotifier,
                      builder: (_, value, __) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 3.h, right: 20.w),
                          child: ProgressBar(
                            progressBarColor: EaselAppTheme.kDarkBlue,
                            thumbColor: EaselAppTheme.kDarkBlue,
                            progress: value.current,
                            baseBarColor: EaselAppTheme.kBlack,
                            bufferedBarColor: EaselAppTheme.kLightGrey,
                            buffered: value.buffered,
                            total: value.total,
                            // timeLabelLocation: viewModel.collapsed ? TimeLabelLocation.none : TimeLabelLocation.below,
                            timeLabelTextStyle: TextStyle(color: EaselAppTheme.kDartGrey, fontWeight: FontWeight.w800, fontSize: 9.sp),
                            thumbRadius: 6.h,
                            timeLabelPadding: 2.h,
                            onSeek: viewModel.seekAudio,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
          SizedBox(
            height: 90.0.h,
          ),
          if (widget.previewFlag) ...[
            _buildThumbnailButton(),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    easelProvider.pauseAudio();
    easelProvider.seekAudio(Duration.zero);
    super.dispose();
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
              audioThumbnailPicker();
            },
            child: SvgPicture.asset(kUploadThumbnail),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioFullScreenIcon() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => AudioWidgetFullScreen(
              thumbnail: easelProvider.audioThumnail,
            ),
          ));
        },
        child: Hero(
          tag: "preview_full_screen",
          child: ClipPath(
            clipper: CustomTriangleClipper(),
            child: Container(
              width: 40.w,
              height: 40.w,
              color: Colors.red,
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(6.0.w),
                child: SvgPicture.asset(
                  kFullScreenIcon,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void audioThumbnailPicker() async {
    final result = await FileUtils.pickFile(NftFormat.supportedFormats[0]);
    if (result != null) {
      final loading = Loading().showLoading(message: kCompressingMessage);
      final file = await FileUtils.compressAndGetFile(File(result.path!));
      easelProvider.setVideoThumbnail(file);
      loading.dismiss();
    }
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
