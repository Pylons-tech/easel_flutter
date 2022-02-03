import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_size_util.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/pylons_round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseFormatScreen extends StatefulWidget {
  final PageController controller;

  const ChooseFormatScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  State<ChooseFormatScreen> createState() => _ChooseFormatScreenState();
}

class _ChooseFormatScreenState extends State<ChooseFormatScreen> {
  late EaselProvider provider;
  NftFormat? _tempFormat;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EaselProvider>(context);
    _tempFormat ??= provider.nftFormat;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 10),
              _CardWidget(
                text: 'Image',
                secondaryText: 'JPG, PNG, SVG, HEIF',
                selected: _tempFormat?.format == 'image',
                icon: 'nft_format_image',
                onTap: () {
                  setState(() {
                    _tempFormat = NftFormat.supportedFormats[0];
                  });
                },
              ),
              const SizedBox(width: 10),
              _CardWidget(
                text: 'Video',
                secondaryText: 'MP4',
                selected: _tempFormat?.format == 'video',
                icon: 'nft_format_video',
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
                text: '3D',
                secondaryText: 'GLTF or GLB',
                selected: _tempFormat?.format == '3d',
                icon: 'nft_format_3d',
                onTap: () {
                  setState(() {
                    _tempFormat = NftFormat.supportedFormats[2];
                  });
                },
              ),
              const SizedBox(width: 10),
              _CardWidget(
                text: 'Audio',
                secondaryText: 'MP3, FLAC or WAV',
                selected: _tempFormat?.format == 'audio',
                icon: 'nft_format_audio',
                onTap: () {
                  setState(() {
                    _tempFormat = NftFormat.supportedFormats[3];
                  });
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            child: PylonsRoundButton(onPressed: () {
              if (_tempFormat?.format != provider.nftFormat.format) {
                provider.initStore();
              }
              provider.setFormat(context, _tempFormat!);
              widget.controller.jumpToPage(1);
            }),
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
    this.selected = false,
  }) : super(key: key);
  final bool selected;
  final String text;
  final String secondaryText;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
              width: screenSize.width(percent: 45),
              height: screenSize.width(percent: 45),
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: selected
                    ? EaselAppTheme.cardBackgroundSelected
                    : EaselAppTheme.cardBackground,
              ),
              child: Image.asset(
                "assets/images/$icon.png",
              )),
        ),
        const VerticalSpace(8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: selected
                  ? EaselAppTheme.kBlue
                  : EaselAppTheme.kBlue.withOpacity(0.5),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        const VerticalSpace(6),
        Text(
          secondaryText,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: EaselAppTheme.kLightGrey,
              fontSize: 15,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
