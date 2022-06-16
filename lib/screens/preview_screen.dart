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
            // Image.asset(kPreviewGradient, width: 1.sw, fit: BoxFit.fill),
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
                      widget.controller.nextPage(duration: const Duration(milliseconds: 10), curve: Curves.easeIn);
                      Navigator.of(context).pop();
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



  // Widget build(BuildContext context) {
  //   final easelProvider = context.watch<EaselProvider>();
  //
  //   return ChangeNotifierProvider<EaselProvider>.value(
  //       value: easelProvider,
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             SizedBox(height: MediaQuery.of(context).viewPadding.top + 20.h),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 IconButton(
  //                   onPressed: () {},
  //                   icon: const Icon(
  //                     Icons.arrow_back_ios,
  //                     color: EaselAppTheme.kBlack,
  //                   ),
  //                 ),
  //                 Text(
  //                   kPreviewNftFileText,
  //                   style: Theme.of(context).textTheme.bodyText1!.copyWith(
  //                     fontSize: 18.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: EaselAppTheme.kDarkText,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 20.w,
  //                 ),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 20.w,
  //             ),
  //             SizedBox(
  //               width: 280.w,
  //               child: Column(
  //                 children: [
  //                   ClipPath(
  //                     clipper: RightSmallBottomClipper(),
  //                     child: SizedBox(
  //                       height: 200.h,
  //                       child: Stack(
  //                         children: [
  //
  //
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               height: 10.w,
  //             ),
  //             // Row(
  //             //   mainAxisAlignment: MainAxisAlignment.end,
  //             //   children: [
  //             //     IconButton(
  //             //         onPressed: () {
  //             //           Navigator.push(
  //             //             context,
  //             //             MaterialPageRoute(builder: (context) => VideoWidgetFullScreen(file: widget.file)),
  //             //           );
  //             //         },
  //             //         icon: Icon(
  //             //           Icons.fullscreen,
  //             //           color: EaselAppTheme.kBlack,
  //             //           size: 20.h,
  //             //         ))
  //             //   ],
  //             // ),
  //             // Padding(
  //             //   padding: EdgeInsets.only(bottom: 70.h),
  //             //
  //             //   ///Don't place const here, it will stop reflecting changes
  //             //   child: VideoProgressWidget(darkMode: false, easelProvider: easelProvider),
  //             // ),
  //             Align(
  //               alignment: Alignment.bottomLeft,
  //               child: Padding(
  //                 padding: EdgeInsets.all(30.h),
  //                 child: InkWell(
  //                   onTap: () {},
  //                   child: SvgPicture.asset(kUploadThumbnail),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  // }

  Widget buildPreviewWidget(EaselProvider provider) {
    switch (provider.nftFormat.format) {
      case kImageText:
        return ImageWidget(file: provider.file!);
      case kVideoText:
        return VideoWidget(file: provider.file!);
      case k3dText:
        return Model3dViewer(file: provider.file!);
      case kAudioText:
        return AudioWidget(file: provider.file!,previewFlag: true,);
    }
    return const SizedBox.shrink();
  }



}


class RightSmallBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width - (size.width * 0.2), size.height)
      ..lineTo(size.width, size.height - (size.height * 0.2))
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class TopLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, size.width)
      ..lineTo(0, size.height)

      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

