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

class UploadScreen extends StatefulWidget {
  final PageController controller;
  const UploadScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  ValueNotifier<bool> showError = ValueNotifier(false);
  ValueNotifier<String> errorText = ValueNotifier("Pick a file");
  late EaselProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EaselProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _UploadWidget(
                      onFilePicked: (result)async{
                        if(result != null){
                          if(FileUtils.getFileSizeInMB(File(result.path!).lengthSync()) <= kFileSizeLimitInMB){
                            await provider.setFile(context, result);
                          }else{
                            errorText.value = '"${result.name}" could not be uploaded';
                            showError.value = true;
                          }

                        }
                      }

                  ),
                  PylonsRoundButton(onPressed: () {
                    if (provider.file != null) {
                      widget.controller.jumpToPage(1);
                    } else {
                      errorText.value = 'Pick a file';
                      showError.value = true;
                    }
                  }),
                ],
              ),),
              const SizedBox(height: 20)

            ]
          ),
          Positioned(
            child: ValueListenableBuilder(
              valueListenable: showError,
              builder: (_, bool value, __) => value ? _ErrorMessageWidget(
                errorMessage: errorText.value,
                onClose: () {
                  showError.value = false;
                },
              ) : const SizedBox.shrink(),
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
          Text(
            "Upload",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const VerticalSpace(5),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.5,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(70),
            decoration: BoxDecoration(
              color: EaselAppTheme.kBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              image:  provider.file != null ? DecorationImage(
                image: FileImage(provider.file!),
                fit: BoxFit.cover
              ) : null
            ),

            child: GestureDetector(
              onTap: () async {
                final result = await FileUtils.pickFile();
                widget.onFilePicked(result);
              },
              child: Assets.fileImage,
            ),
          ),
          const VerticalSpace(5),
          Text(
            provider.fileName,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: EaselAppTheme.kLightGrey,
                ),
          ),
          Text(
            "${provider.fileSize}MB",
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: EaselAppTheme.kLightGrey,
                ),
          ),
        ],
      ),
    );
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
                  // width: screenSize.width(),
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
                      "• ${kFileSizeLimitInMB}MB Limit",
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
