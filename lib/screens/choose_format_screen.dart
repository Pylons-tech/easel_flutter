import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../widgets/pylons_button.dart';

class ChooseFormatScreen extends StatefulWidget {
  final PageController controller;

  const ChooseFormatScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<ChooseFormatScreen> createState() => _ChooseFormatScreenState();
}

class _ChooseFormatScreenState extends State<ChooseFormatScreen> {
  NftFormat? _tempFormat;

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
              Text("$kFileSizeLimitInGB$kUploadHintAll",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: EaselAppTheme.kLightPurple, fontSize: 15.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 10),
                  _CardWidget(
                    text: NftFormat.supportedFormats[0].format,
                    secondaryText: NftFormat.supportedFormats[0].getExtensionsList(),
                    selected: _tempFormat?.format == NftFormat.supportedFormats[0].format,
                    icon: NftFormat.supportedFormats[0].badge,
                    backColor: NftFormat.supportedFormats[0].color,
                    onTap: () {
                      setState(() {
                        _tempFormat = NftFormat.supportedFormats[0];
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _CardWidget(
                    text: NftFormat.supportedFormats[1].format,
                    secondaryText: NftFormat.supportedFormats[1].getExtensionsList(),
                    selected: _tempFormat?.format == NftFormat.supportedFormats[1].format,
                    icon: NftFormat.supportedFormats[1].badge,
                    backColor: NftFormat.supportedFormats[1].color,
                    onTap: () {
                      setState(() {
                        _tempFormat = NftFormat.supportedFormats[1];
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 10),
                  _CardWidget(
                    text: NftFormat.supportedFormats[2].format,
                    secondaryText: NftFormat.supportedFormats[2].getExtensionsList(),
                    selected: _tempFormat?.format == NftFormat.supportedFormats[2].format,
                    icon: NftFormat.supportedFormats[2].badge,
                    backColor: NftFormat.supportedFormats[2].color,
                    onTap: () {
                      setState(() {
                        _tempFormat = NftFormat.supportedFormats[2];
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _CardWidget(
                    text: NftFormat.supportedFormats[3].format,
                    secondaryText: NftFormat.supportedFormats[3].getExtensionsList(),
                    selected: _tempFormat?.format == NftFormat.supportedFormats[3].format,
                    icon: NftFormat.supportedFormats[3].badge,
                    backColor: NftFormat.supportedFormats[3].color,
                    onTap: () {
                      setState(() {
                        _tempFormat = NftFormat.supportedFormats[3];
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
                margin: EdgeInsets.only(right: 25.w, bottom: 40.h),
                child: PylonsButton(
                  onPressed: () {
                    if (_tempFormat?.format != provider.nftFormat.format) {
                      provider.initStore();
                    }
                    provider.setFormat(context, _tempFormat!);
                    widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                  },
                  btnText: kContinue,
                  isBlue: false,
                  showArrow: true,
                )),
          ),
        ],
      ),
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    Key? key,
    required this.text,
    required this.secondaryText,
    required this.icon,
    required this.onTap,
    required this.backColor,
    this.selected = false,
  }) : super(key: key);
  final bool selected;
  final String text;
  final String secondaryText;
  final String icon;
  final Color backColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: ScreenResponsive(
              tabletScreen: (BuildContext context) => Container(
                  width: 0.21.sw,
                  height: 0.21.sw,
                  padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 4.5.h),
                  decoration: BoxDecoration(color: backColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        text,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: EaselAppTheme.kWhite, fontSize: 15.sp, fontWeight: FontWeight.w400),
                      ),
                      SvgPicture.asset(icon)
                    ],
                  )),
              mobileScreen: (BuildContext context) => Container(
                    width: 0.25.sw,
                    height: 0.25.sw,
                    padding: EdgeInsets.symmetric(horizontal: 0.06.sw, vertical: 5.h),
                    decoration: BoxDecoration(color: backColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: EaselAppTheme.kWhite, fontSize: 15.sp, fontWeight: FontWeight.w400),
                        ),
                        SvgPicture.asset(icon),
                      ],
                    ),
                  )),
        ),
        const VerticalSpace(6),
        SizedBox(
          width: 0.4.sw,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: EaselAppTheme.kLightPurple, fontSize: 12.sp, fontWeight: FontWeight.w400),
                text: secondaryText),
          ),
        ),
        const VerticalSpace(6),
        Container(
          width: 15.w,
          height: 15.h,
          decoration: BoxDecoration(color: selected ? backColor : EaselAppTheme.kLightGrey),
        )
      ],
    );
  }
}
