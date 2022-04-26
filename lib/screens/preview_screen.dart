import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/model_viewer.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:easel_flutter/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
            if (provider.nftFormat.format == kImageText) ...[ImageWidget(file: provider.file!)],
            if (provider.nftFormat.format == kVideoText) ...[VideoWidget(file: provider.file!)],
            if (provider.nftFormat.format == k3dText) ...[Model3dViewer(file: provider.file!)],
            if (provider.nftFormat.format == kAudioText) ...[AudioWidget(file: provider.file!)],
            Padding(padding: EdgeInsets.only(bottom: 30.h, right: 20.w),
            child: Align(
              alignment: Alignment.bottomRight,
              child: PylonsButton(
                  onPressed: () {
                    widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                  },
                  btnText: kContinue,
                  isBlue: false,
                  showArrow: true),
            ),)

          ],
        ),
      ),
    );
  }
}
