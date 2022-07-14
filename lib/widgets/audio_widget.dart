import 'dart:io';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../models/nft_format.dart';
import '../screens/custom_widgets/step_labels.dart';
import '../screens/custom_widgets/steps_indicator.dart';
import '../utils/easel_app_theme.dart';
import '../utils/file_utils.dart';
import '../utils/space_utils.dart';
import 'loading.dart';

class AudioWidget extends StatefulWidget {
  final File? file;
  final String? filePath;
  final bool previewFlag;

  const AudioWidget({Key? key, this.file, required this.previewFlag, this.filePath}) : super(key: key);

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> with WidgetsBindingObserver {
  EaselProvider get easelProvider => GetIt.I.get();
  final ValueNotifier<int> _currentStep = ValueNotifier(0);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  initState() {
    if (!easelProvider.isInitializedForFile) {
      if (widget.file != null) {
        easelProvider.initializeAudioPlayerForFile();
        return;
      }
    }
    if (!easelProvider.isInitializedForNetwork) {
      if (widget.filePath != null) {
        easelProvider.initializeAudioPlayer(publishedNFTUrl: widget.filePath);
        return;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        easelProvider.setAudioThumbnail(null);
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Consumer<EaselProvider>(builder: (context, viewModel, _) {
        return Container(
          decoration: BoxDecoration(image: viewModel.audioThumbnail != null ? DecorationImage(image: FileImage(viewModel.audioThumbnail!), fit: BoxFit.fill) : null),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 15.0.h,
                  ),
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
                            easelProvider.setAudioThumbnail(null);

                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: EaselAppTheme.kBlack,
                          ),
                        ),
                        Text(
                          kPreviewYourNFTText,
                          key: const Key(kPreviewYourNFTText),
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
                  SizedBox(
                    height: 150.0.h,
                  ),
                  SizedBox(
                      width: 330.0.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.w, bottom: 10.h, top: 10.h, left: 5.w),
                            child: ValueListenableBuilder<ButtonState>(
                              valueListenable: viewModel.buttonNotifier,
                              builder: (_, value, __) {
                                switch (value) {
                                  case ButtonState.loading:
                                    return SizedBox(height: 35.h, width: 22.h, child: CircularProgressIndicator(strokeWidth: 2.w, color: Colors.black));
                                  case ButtonState.paused:
                                    return InkWell(
                                      onTap: viewModel.playAudio,
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: EaselAppTheme.kDarkBlue,
                                        size: 35.h,
                                      ),
                                    );

                                  case ButtonState.playing:
                                    return InkWell(
                                      onTap: viewModel.pauseAudio,
                                      child: Icon(
                                        Icons.pause,
                                        color: EaselAppTheme.kDarkBlue,
                                        size: 35.h,
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
                                    thumbRadius: 10.h,
                                    timeLabelPadding: 3.h,
                                    onSeek: viewModel.seekAudio,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 90.0.h,
                  ),
                  if (shouldShowThumbnailButtonOrStepsOrNot()) ...[
                    _buildThumbnailButton(),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  bool shouldShowThumbnailButtonOrStepsOrNot() {
    return !widget.previewFlag;
  }

  @override
  void dispose() {
    easelProvider.disposeAudioController();
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

  void audioThumbnailPicker() async {
    final result = await FileUtils.pickFile(NftFormat.supportedFormats[0]);
    if (result != null) {
      final loading = Loading().showLoading(message: "compressing_thumbnail".tr());
      final file = await FileUtils.compressAndGetFile(File(result.path!));
      easelProvider.setAudioThumbnail(file);
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
