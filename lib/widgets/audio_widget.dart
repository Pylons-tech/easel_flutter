import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../models/nft_format.dart';
import '../utils/easel_app_theme.dart';
import 'loading.dart';

class AudioWidget extends StatefulWidget {
  final File? file;
  final String? filePath;
  final bool previewFlag;

  const AudioWidget({Key? key, this.file, required this.previewFlag, this.filePath}) : super(key: key);

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> with WidgetsBindingObserver {
  EaselProvider get easelProvider => GetIt.I.get();
  Repository get repository => GetIt.I.get<Repository>();

  @override
  initState() {
    if (!easelProvider.isInitializedForFile) {
      if (widget.file != null) {
        easelProvider.initializeAudioPlayerForFile();
        return;
      }
    }
    if (!easelProvider.isInitializedForNetwork) {
      if (widget.filePath != null) {
        easelProvider.initializeAudioPlayer(publishedNFTUrl: widget.filePath);
        return;
      }
    }

    super.initState();
  }

  BoxDecoration getAudioBackgroundDecoration({required EaselProvider viewModel}) {
    if (widget.previewFlag && viewModel.audioThumbnail == null) {
      return const BoxDecoration();
    }
    if (widget.previewFlag && viewModel.audioThumbnail != null) {
      return BoxDecoration(image: DecorationImage(image: FileImage(viewModel.audioThumbnail!), fit: BoxFit.fitHeight));
    }
    return BoxDecoration(image: viewModel.nft.thumbnailUrl.isNotEmpty ? DecorationImage(image: CachedNetworkImageProvider(viewModel.nft.thumbnailUrl), fit: BoxFit.fitHeight) : null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        easelProvider.setAudioThumbnail(null);
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Consumer<EaselProvider>(builder: (context, viewModel, _) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: getAudioBackgroundDecoration(viewModel: viewModel),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 220.0.h,
                  ),

                  SizedBox(
                    height: 120.0.h,
                  ),
                  if (shouldShowThumbnailButtonOrStepsOrNot()) ...[
                    _buildThumbnailButton(),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  bool shouldShowThumbnailButtonOrStepsOrNot() {
    return widget.previewFlag;
  }

  @override
  void dispose() {
    easelProvider.disposeAudioController();
    super.dispose();
  }

  Widget _buildThumbnailButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20.h),
        child: SizedBox(
          height: 120.h,
          width: 120.w,
          child: InkWell(
            onTap: () {
              audioThumbnailPicker();
            },
            child: SvgPicture.asset(kUploadThumbnail),
          ),
        ),
      ),
    );
  }

  void audioThumbnailPicker() async {
    final pickedFile = await repository.pickFile(NftFormat.supportedFormats[0]);
    final result = pickedFile.getOrElse(() => PickedFileModel(path: "", fileName: "", extension: ""));
    if (result.path.isEmpty) {
      return;
    }
    final loading = Loading()..showLoading(message: "compressing_thumbnail".tr());
    final compressedFile = await repository.compressAndGetFile(File(result.path));
    final file = compressedFile.getOrElse(() => null);
    easelProvider.setAudioThumbnail(file);
    loading.dismiss();
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
