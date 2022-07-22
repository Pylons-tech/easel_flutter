import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';

class ProgressBarBuilder extends StatelessWidget {
  final WidgetBuilder audioProgressBar;
  final WidgetBuilder videoProgressBar;
  final String assetType;

  const ProgressBarBuilder({Key? key, required this.audioProgressBar, required this.videoProgressBar, required this.assetType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (assetType) {
      case kVideoText:
        return videoProgressBar(context);
      case kAudioText:
        return audioProgressBar(context);
      default:
        return const SizedBox();
    }
  }
}
