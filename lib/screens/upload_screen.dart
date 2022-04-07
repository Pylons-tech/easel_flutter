import 'dart:io';
import 'dart:ui';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../widgets/pylons_button.dart';

class UploadScreen extends StatefulWidget {
  final PageController controller;

  const UploadScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  ValueNotifier<bool> showError = ValueNotifier(false);
  ValueNotifier<String> errorText = ValueNotifier("Pick a file");

  @override
  Widget build(BuildContext context) {
    EaselProvider provider = context.read();
    return Scaffold(
      body: Stack(
        children: [
          Column(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _UploadWidget(onFilePicked: (result) async {
                    if (result != null) {
                      if (FileUtils.getFileSizeInGB(File(result.path!).lengthSync()) <= kFileSizeLimitInGB) {
                        await provider.setFile(context, result);
                      } else {
                        errorText.value = '"${result.name}" could not be uploaded';
                        showError.value = true;
                      }
                    }
                  }),
                  Column(
                    children: NftFormat.supportedFormats
                        .map(
                          (format) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                              child: Row(children: [
                                SizedBox(
                                  height: 22.h,
                                  width: 40.w,
                                  child: SvgPicture.asset(format.badge),
                                ),
                                SizedBox(
                                  width: 72.w,
                                  child: Text(format.format,
                                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                          color: EaselAppTheme.kDartGrey02,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w800)),
                                ),
                                SizedBox(
                                  width: 0.6.sw,
                                  child: Text(format.getExtensionsList(),
                                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                          color: EaselAppTheme.kLightPurple,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ])),
                        )
                        .toList(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0.12.sw),
                      child: PylonsButton(
                          onPressed: () {
                            if (provider.file != null) {
                              context.read<EaselProvider>().priceController.clear();
                              widget.controller
                                  .nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                            } else {
                              errorText.value = kErrFileNotPicked;
                              showError.value = true;
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
            const SizedBox(height: 20),
          ]),
          Positioned(
            child: ValueListenableBuilder(
              valueListenable: showError,
              builder: (_, bool value, __) => value
                  ? _ErrorMessageWidget(
                      errorMessage: errorText.value,
                      onClose: () {
                        showError.value = false;
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          )
        ],
      ),
    );
  }
}

class _UploadWidget extends StatefulWidget {
  final Function(PlatformFile?) onFilePicked;

  const _UploadWidget({
    Key? key,
    required this.onFilePicked,
  }) : super(key: key);

  @override
  State<_UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<_UploadWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EaselProvider>(
      builder: (_, provider, __) => Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 0.26.sh,
            child: GestureDetector(
                onTap: () async {
                  final result = await FileUtils.pickFile();
                  if (result == null) {
                    context.show(message: kErrUnsupportedFormat);
                  } else {
                    provider.resolveNftFormat(context, result.extension!);
                    widget.onFilePicked(result);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(kSvgDashedBox),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.18.sw),
                            child: Text(provider.fileName.isEmpty ? kTapToSelect : provider.fileName,
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: EaselAppTheme.kLightPurple,
                                    fontSize: provider.fileName.isEmpty ? 22.sp : 16.sp,
                                    fontWeight: FontWeight.w800))),
                        SvgPicture.asset(kSvgFileUpload),
                        Text(provider.fileName.isEmpty ? "${kFileSizeLimitInGB}GB Limit" : provider.fileSize,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: EaselAppTheme.kLightPurple, fontSize: 15.sp, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key, required this.errorMessage, required this.onClose}) : super(key: key);

  final String errorMessage;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          child: SizedBox(
            width: 1.0.sw,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  height: 0.85.sh,
                  // width: screenSize.width(),
                  decoration: BoxDecoration(color: EaselAppTheme.kWhite.withOpacity(0.2)),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 0.85.sw,
          margin: const EdgeInsets.only(
            left: 20,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          decoration: BoxDecoration(
              color: EaselAppTheme.kRed.withOpacity(0.75),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14))),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: onClose,
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 30,
                      )),
                  const HorizontalSpace(20),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "• ${kFileSizeLimitInGB}GB Limit",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 16.sp),
                    ),
                    Text(
                      "• JPG, JPEG or PNG format",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 16.sp),
                    ),
                    Text(
                      "• One file per upload",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
