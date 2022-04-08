import 'dart:io';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _UploadWidget(onFilePicked: (result) async {
                if (result != null) {
                  provider.resolveNftFormat(context, result.extension!);
                  if (FileUtils.getFileSizeInGB(File(result.path!).lengthSync()) <= kFileSizeLimitInGB) {
                    await provider.setFile(context, result);
                  } else {
                    errorText.value = '"${result.name}" could not be uploaded';
                    showError.value = true;
                  }
                } else {
                  errorText.value = kErrUnsupportedFormat;
                  showError.value = true;
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
                                      color: EaselAppTheme.kDartGrey02, fontSize: 18.sp, fontWeight: FontWeight.w800)),
                            ),
                            SizedBox(
                              width: 0.6.sw,
                              child: Text(format.getExtensionsList(),
                                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: EaselAppTheme.kLightPurple, fontSize: 18.sp, fontWeight: FontWeight.w800)),
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
                          widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
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
          ValueListenableBuilder(
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
      builder: (_, provider, __) => Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: SizedBox(
          width: 0.8.sw,
          child: GestureDetector(
              onTap: () async {
                final result = await FileUtils.pickFile();
                widget.onFilePicked(result);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(kSvgDashedBox),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.18.sw),
                          child: Text(provider.fileName.isEmpty ? kTapToSelect : provider.fileName,
                              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  color: EaselAppTheme.kLightPurple,
                                  fontSize: provider.fileName.isEmpty ? 22.sp : 16.sp,
                                  fontWeight: FontWeight.w800))),
                      SizedBox(height: 25.h),
                      SvgPicture.asset(kSvgFileUpload),
                      SizedBox(height: 10.h),
                      Text(provider.fileName.isEmpty ? "${kFileSizeLimitInGB}GB Limit" : provider.fileSize,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: EaselAppTheme.kLightPurple, fontSize: 15.sp, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ],
              )),
        ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(kSvgUploadErrorBG),
          Container(
            width: double.infinity,
            height: 0.9.sw,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(kSvgCloseIcon),
                SizedBox(height: 15.h),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• ${kFileSizeLimitInGB}GB Limit",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w800)),
                      Text("• Image, Video, 3D or Audio",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w800)),
                      Text("• One file per upload",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  child: SizedBox(
                    width: 0.5.sw,
                    height: 0.12.sw,
                    child: Stack(
                      children: [
                        SvgPicture.asset(kSvgCloseButton, fit: BoxFit.cover),
                        Center(
                          child: Text(
                            kCloseText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 16.sp, color: EaselAppTheme.kWhite, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    onClose();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
