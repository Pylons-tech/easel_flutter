import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../easel_provider.dart';
import '../utils/easel_app_theme.dart';

class AudioWidgetFullScreen extends StatelessWidget {
  final File? thumbnail;

  const AudioWidgetFullScreen({Key? key, this.thumbnail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: "preview_full_screen",
        child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: (thumbnail != null)
                    ? DecorationImage(
                        image: FileImage(
                          thumbnail!,
                        ),
                        fit: BoxFit.fill,
                      )
                    : null),
            child: Column(
              children: [
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
              ],
            )),
      ),
    );
  }
}
