import 'dart:io';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;
import 'package:provider/provider.dart';

import '../utils/file_utils.dart';

class ChooseFormatScreen extends StatefulWidget {
  final PageController controller;

  const ChooseFormatScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<ChooseFormatScreen> createState() => _ChooseFormatScreenState();
}

class _ChooseFormatScreenState extends State<ChooseFormatScreen> {
  NftFormat? _tempFormat;
  ValueNotifier<String> errorText = ValueNotifier("Pick a file");

  void proceedToNext(PlatformFile? result) async {
    EaselProvider provider = context.read();

    if (result != null) {
      provider.resolveNftFormat(context, result.extension!);
      if (FileUtils.getFileSizeInGB(File(result.path!).lengthSync()) <= kFileSizeLimitInGB) {
        await provider.setFile(context, result);
        widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        errorText.value = '"${result.name}" could not be uploaded';
        showErrorDialog();
      }
    } else {
      errorText.value = kErrUnsupportedFormat;
      showErrorDialog();
    }
  }

  void showErrorDialog() {
    showDialog(
        context: context,
        builder: (context) => _ErrorMessageWidget(
              errorMessage: errorText.value,
              onClose: () {
                Navigator.of(context).pop();
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    EaselProvider provider = context.read();
    _tempFormat ??= provider.nftFormat;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text("NOTICE:\n$kFileSizeLimitInGB$kUploadHintAll",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: EaselAppTheme.kLightPurple, fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 10),
                  _CardWidget(
                      typeIdx: 0,
                      selected: _tempFormat?.format == NftFormat.supportedFormats[0].format,
                      onFilePicked: (result) async {
                        proceedToNext(result);
                      }),
                  const SizedBox(width: 10),
                  _CardWidget(
                      typeIdx: 1,
                      selected: _tempFormat?.format == NftFormat.supportedFormats[1].format,
                      onFilePicked: (result) async {
                        proceedToNext(result);
                      }),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 10),
                  _CardWidget(
                      typeIdx: 2,
                      selected: _tempFormat?.format == NftFormat.supportedFormats[2].format,
                      onFilePicked: (result) async {
                        proceedToNext(result);
                      }),
                  const SizedBox(width: 10),
                  _CardWidget(
                      typeIdx: 3,
                      selected: _tempFormat?.format == NftFormat.supportedFormats[3].format,
                      onFilePicked: (result) async {
                        proceedToNext(result);
                      }),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    Key? key,
    required this.typeIdx,
    this.selected = false,
    required this.onFilePicked,
  }) : super(key: key);

  final Function(PlatformFile?) onFilePicked;
  final int typeIdx;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            EaselProvider provider = context.read();
            provider.setFormat(context, NftFormat.supportedFormats[typeIdx]);
            final result = await FileUtils.pickFile(provider.nftFormat);
            onFilePicked(result);
          },
          child: Container(
              width: 0.4.sw,
              height: 0.4.sw,
              padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 4.5.h),
              decoration: BoxDecoration(color: NftFormat.supportedFormats[typeIdx].color),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(NftFormat.supportedFormats[typeIdx].badge),
                  Column(
                    children: [
                      Text(
                        NftFormat.supportedFormats[typeIdx].format,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: EaselAppTheme.kWhite, fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 3.h),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: EaselAppTheme.kWhite, fontSize: 12.sp, fontWeight: FontWeight.w600),
                            text: NftFormat.supportedFormats[typeIdx].getExtensionsList()),
                      ),
                    ],
                  ),
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: selected ? NftFormat.supportedFormats[typeIdx].color : EaselAppTheme.kWhite,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  )
                ],
              )),
        ),
      ],
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key, required this.errorMessage, required this.onClose}) : super(key: key);

  final String errorMessage;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ScreenResponsive(
      mobileScreen: (context) => buildMobile(context),
      tabletScreen: (context) => buildTablet(context),
    );
  }

  Padding buildTablet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.17.sw),
      child: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: svg_provider.Svg(kSvgUploadErrorBG))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              kSvgCloseIcon,
              height: 30.h,
            ),
            SizedBox(height: 30.h),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 30.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ${kFileSizeLimitInGB}GB Limit",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w800)),
                Text(kUploadHint2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w800)),
                Text(kUploadHint3,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w800)),
              ],
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              child: SizedBox(
                width: 0.35.sw,
                height: 0.09.sw,
                child: Stack(
                  children: [
                    Positioned.fill(child: SvgPicture.asset(kSvgCloseButton, fit: BoxFit.cover)),
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
    );
  }

  Padding buildMobile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.10.sw),
      child: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: svg_provider.Svg(kSvgUploadErrorBG))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            SvgPicture.asset(
              kSvgCloseIcon,
              height: 30.h,
            ),
            SizedBox(height: 30.h),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 30.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ${kFileSizeLimitInGB}GB Limit",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w800)),
                Text(kUploadHint2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w800)),
                Text(kUploadHint3,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w800)),
              ],
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              child: SizedBox(
                width: 0.35.sw,
                height: 0.09.sw,
                child: Stack(
                  children: [
                    Positioned.fill(child: SvgPicture.asset(kSvgCloseButton, fit: BoxFit.cover)),
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
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
