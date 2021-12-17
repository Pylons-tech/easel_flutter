import 'dart:io';
import 'dart:ui';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_size_util.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/assets.dart';
import 'package:easel_flutter/widgets/pylons_round_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easel_flutter/models/media_type.dart';

class StartScreen extends StatefulWidget {
  final PageController controller;
  final Function(int?) setMediaType;
  const StartScreen(
      {Key? key, required this.controller, required this.setMediaType})
      : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  ValueNotifier<bool> showError = ValueNotifier(false);
  ValueNotifier<String> errorText = ValueNotifier(kPickFile);
  late EaselProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EaselProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _UploadWidget(
                        controller: widget.controller,
                        setMediaType: widget.setMediaType),
                    PylonsRoundButton(onPressed: () {
                      if (provider.file != null) {
                        widget.controller.jumpToPage(1);
                      } else {
                        errorText.value = kPickFile;
                        showError.value = true;
                      }
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ]),
          ),
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
  final PageController controller;
  final Function(int?) setMediaType;
  const _UploadWidget({
    Key? key,
    required this.controller,
    required this.setMediaType,
  }) : super(key: key);

  @override
  State<_UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<_UploadWidget> {
  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    return Consumer<EaselProvider>(
      builder: (_, provider, __) => Column(
        children: [
          Text(
            kChooseNft,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const VerticalSpace(5),
          Container(
              width: sizeWidth,
              height: sizeWidth + 50,
              child: GridView.count(
                  crossAxisCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  childAspectRatio: 0.8,
                  scrollDirection: Axis.vertical,
                  children: List.generate(kinds.length, (index) {
                    return Center(
                      child: SelectKind(
                          kind: kinds[index],
                          provider: provider,
                          widget: widget),
                    );
                  }))),
        ],
      ),
    );
  }
}

class NftKind {
  const NftKind(
      {required this.index,
      required this.title,
      required this.subTitle,
      required this.iconName});
  final int index;
  final String title;
  final String subTitle;
  final String iconName;
}

const List<NftKind> kinds = <NftKind>[
  NftKind(
      index: 0, title: kImages, subTitle: kImageType, iconName: kImageIconPath),
  NftKind(
      index: 1, title: kVideos, subTitle: kVideoType, iconName: kVideoIconPath),
  NftKind(index: 2, title: k3Ds, subTitle: k3DType, iconName: k3DIconPath),
  NftKind(
      index: 3, title: kAudios, subTitle: kAudioType, iconName: kAudioIconPath),
];

class SelectKind extends StatelessWidget {
  const SelectKind(
      {Key? key,
      required this.kind,
      required this.provider,
      required this.widget})
      : super(key: key);
  final NftKind kind;
  final EaselProvider provider;
  final _UploadWidget widget;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.subtitle1;
    final paddingSize = MediaQuery.of(context).size.width / 2;

    return Column(children: <Widget>[
      Container(
          width: paddingSize,
          height: paddingSize - 40,
          margin: const EdgeInsets.all(8),
          decoration:
              BoxDecoration(color: EaselAppTheme.kBlue.withOpacity(0.1)),
          child: SizedBox(
              child: IconButton(
            icon: Image.asset(kind.iconName),
            padding: const EdgeInsets.all(33),
            onPressed: () {
              widget.setMediaType(kind.index);
              widget.controller.jumpToPage(1);
            },
          ))),
      Text(
        kind.title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      Text(
        kind.subTitle,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.lightGreen, fontSize: 12),
      ),
    ]);
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget(
      {Key? key, required this.errorMessage, required this.onClose})
      : super(key: key);

  final String errorMessage;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);

    return Stack(
      children: [
        Positioned(
          right: 0,
          child: SizedBox(
            width: screenSize.width(),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  height: screenSize.height(percent: 85),
                  decoration: BoxDecoration(
                      color: EaselAppTheme.kWhite.withOpacity(0.2)),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: screenSize.width(percent: 85),
          margin: const EdgeInsets.only(
            left: 20,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          decoration: BoxDecoration(
              color: EaselAppTheme.kRed.withOpacity(0.75),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14))),
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
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "• JPG, JPEG or PNG format",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "• One file per upload",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.white, fontSize: 16),
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
