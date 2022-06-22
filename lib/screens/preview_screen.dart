import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/model_viewer.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:easel_flutter/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../utils/easel_app_theme.dart';

class PreviewScreen extends StatefulWidget {
  final PageController controller;

  const PreviewScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EaselProvider>(
        builder: (_, provider, __) => Stack(
          children: [
            buildPreviewWidget(provider),
            Column(children: [
              SizedBox(height: MediaQuery.of(context).viewPadding.top + 20.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.sp),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: EaselAppTheme.kWhite,
                      ),
                    )),
              )
            ]),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h, right: 25.w),
              child: Align(
                alignment: Alignment.bottomRight,
                child: PylonsButton(
                    onPressed: () {
                      if (provider.nftFormat.format == kAudioText) {
                        if (provider.audioThumnail != null) {
                          widget.controller.nextPage(duration: const Duration(milliseconds: 10), curve: Curves.easeIn);
                          Navigator.of(context).pop();
                        } else {
                          context.show(message: kErrAddAudioThumbnil);
                        }
                      } else {
                        widget.controller.nextPage(duration: const Duration(milliseconds: 10), curve: Curves.easeIn);
                        Navigator.of(context).pop();
                      }
                    },
                    btnText: kContinue,
                    isBlue: false,
                    showArrow: true),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPreviewWidget(EaselProvider provider) {
    switch (provider.nftFormat.format) {
      case kImageText:
        return ImageWidget(file: provider.file!);
      case kVideoText:
        return VideoWidget(file: provider.file!, previewFlag: false,);
      case k3dText:
        return Model3dViewer(file: provider.file!);
      case kAudioText:
        return AudioWidget(
          file: provider.file!,
          previewFlag: false,
        );
    }
    return const SizedBox.shrink();
  }
}
