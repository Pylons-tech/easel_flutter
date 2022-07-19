import 'dart:io';
import 'dart:math';

import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'constants.dart';

abstract class FileUtilsHelper {
  /// This function picks a file with the given format from device storage
  /// Input: [format] it is the file format which needs to be picked from local storage
  /// returns [PlatformFile] the selected file or null if aborted
  Future<PickedFileModel> pickFile(NftFormat format);

  /// This function takes the file and returns a compressed version of that file
  /// Input: [file] it takes the file that needs to be compressed
  /// Output: [File] returns the compressed file
  Future<File?> compressAndGetFile(File file);

  /// This function is used to launch the link generated and open the link in external source platform
  /// Input: [url] is the link to be launched by the launcher
  Future<void> launchMyUrl({required String url});
}

class FileUtilsHelperImpl implements FileUtilsHelper {
  ImageCropper imageCropper;
  FilePicker filePicker;

  FileUtilsHelperImpl({required this.imageCropper, required this.filePicker});

  @override
  Future<PickedFileModel> pickFile(NftFormat format) async {
    FileType _type;
    List<String>? allowedExtensions;
    switch (format.format) {
      case NFTTypes.image:
        if (Platform.isAndroid) {
          _type = FileType.custom;
          allowedExtensions = imageAllowedExts;
          break;
        }
        _type = FileType.image;
        break;

      case NFTTypes.video:
        _type = FileType.video;
        break;

      case NFTTypes.audio:
        if (!Platform.isAndroid) {
          _type = FileType.custom;
          allowedExtensions = audioAllowedExts;
        } else {
          _type = FileType.audio;
        }
        break;
      default:
        _type = FileType.any;
        break;
    }

    FilePickerResult? result = await filePicker.pickFiles(type: _type, allowedExtensions: allowedExtensions);

    if (result == null) {
      return PickedFileModel(
        path: '',
        fileName: '',
        extension: '',
      );
    }

    if (format.format == NFTTypes.image && result.files.single.path != null) {
      final cropperImage = await cropImage(filePath: result.files.single.path!);
      return PickedFileModel(
        path: cropperImage,
        fileName: result.files.single.name,
        extension: result.files.single.extension ?? "",
      );
    }

    return PickedFileModel(
      path: result.files.single.path ?? "",
      fileName: result.files.single.name,
      extension: result.files.single.extension ?? "",
    );
  }

  @override
  Future<File?> compressAndGetFile(File file) async {
    var tempDirectory = await getTemporaryDirectory();
    var timeStamp = DateTime.now();
    var result = await FlutterImageCompress.compressAndGetFile(file.path, '${tempDirectory.path}/$timeStamp.jpg', quality: kFileCompressQuality);

    return result;
  }


  @override
  Future<void> launchMyUrl({required String url}) async {
    final canLaunch = await canLaunchUrlString(url);
    if (canLaunch) {
      launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw ("cannot_launch_url".tr());
    }
  }

  Future<String> cropImage({required String filePath}) async {
    try {
      CroppedFile? croppedFile = await imageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9],
        uiSettings: [
          AndroidUiSettings(toolbarTitle: kPylons, toolbarColor: EaselAppTheme.kBlue, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
          IOSUiSettings(
            title: kPylons,
          ),
        ],
      );
      return croppedFile?.path ?? "";
    } catch (e) {
      print(e);
      return "";
    }
  }
}
