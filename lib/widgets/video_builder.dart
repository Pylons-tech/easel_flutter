
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';

class VideoBuilder extends StatelessWidget {
  final WidgetBuilder onVideoLoading;
  final WidgetBuilder onVideoHasError;
  final WidgetBuilder onVideoInitialized;
  final EaselProvider easelProvider;

  const VideoBuilder({
    Key? key,
    required this.onVideoLoading,
    required this.onVideoHasError,
    required this.onVideoInitialized,
    required this.easelProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (easelProvider.isVideoLoading) {
      return onVideoLoading(context);
    } else if (easelProvider.videoLoadingError.isNotEmpty) {
      return onVideoHasError(context);
    } else if (easelProvider.videoPlayerController.value.isInitialized) {
      return onVideoInitialized(context);
    }
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(EaselAppTheme.kBlack),
      ),
    );
  }
}
