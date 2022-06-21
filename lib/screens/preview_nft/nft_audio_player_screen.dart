import 'dart:ui';

import 'package:easel_flutter/screens/preview_nft/nft_audio_progress_widget.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NFTAudioPlayerScreen extends StatelessWidget {
  const NFTAudioPlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EaselAppTheme.kBlack,
      child: Stack(
        children: [
          Image.asset(
            kSvgNftFormatAudio,
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height,
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
                      child: AudioProgressWidget(),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
