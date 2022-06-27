import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AudioProgressWidget extends StatefulWidget {

  const AudioProgressWidget({Key? key}) : super(key: key);

  @override
  _AudioProgressWidgetState createState() => _AudioProgressWidgetState();
}

class _AudioProgressWidgetState extends State<AudioProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EaselProvider>(builder: (context, viewModel, _) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10.w, bottom: 10.h, top: 10.h, left: 5.w),
            child: ValueListenableBuilder<ButtonState>(
              valueListenable: viewModel.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return SizedBox(height: 22.h, width: 22.h, child: CircularProgressIndicator(strokeWidth: 2.w, color: EaselAppTheme.kWhite));
                  case ButtonState.paused:
                    return InkWell(
                      onTap: viewModel.playAudio,
                      child:  Icon(
                      Icons.play_arrow_outlined,
                        color: EaselAppTheme.kWhite,
                        size: 22.h,
                      ),
                    );

                  case ButtonState.playing:
                    return InkWell(
                      onTap: viewModel.pauseAudio,
                      child: Icon(
                        Icons.pause,
                        color: EaselAppTheme.kWhite,
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
                  padding: EdgeInsets.only(bottom: 0 , right: 10.w),
                  child: ProgressBar(
                    progressBarColor: EaselAppTheme.kWhite,
                    thumbColor: EaselAppTheme.kWhite,
                    progress: value.current,
                    baseBarColor: EaselAppTheme.kGrey,
                    bufferedBarColor: EaselAppTheme.kWhite,
                    buffered: value.buffered,
                    total: value.total,
                    timeLabelLocation: TimeLabelLocation.none ,
                    timeLabelTextStyle: TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w800, fontSize: 9.sp),
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
    });
  }
}
