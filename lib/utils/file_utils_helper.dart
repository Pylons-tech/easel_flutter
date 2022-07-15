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

  /// This function checks if a file path extension svg or not
  /// Input: [filePath] the file path
  /// Output: [true] if the filepath has svg extension and [false] otherwise
  bool isSvgFile(String filePath);

  /// This function checks if a file path extension svg or not
  /// Input: [filePath] the path of the file
  /// Output: [true] if the filepath has svg extension and [false] otherwise
  String getExtension(String fileName);

  /// This function is used to get the file size in GBs
  /// Input: [fileLength] the file length in bytes
  /// Output: [double] returns the file size in GBs in double format
  double getFileSizeInGB(int fileLength);

  /// This function is used to get the file size in String format
  /// Input: [fileLength] the file length in bytes and [precision] sets to [2] if not given
  /// Output: [String] returns the file size in String format
  String getFileSizeString({required int fileLength, int precision = 2});

  /// This function is used to generate the NFT link to be shared with others after publishing
  /// Input: [recipeId] and [cookbookId] used in the link generation as query parameters
  /// Output: [String] returns the generated NFTs link to be shared with others
  String generateEaselLinkForShare({required String recipeId, required String cookbookId});

  /// This function is used to generate the NFT link to be open in the pylons wallet
  /// Input: [recipeId] and [cookbookId] used in the link generation as query parameters
  /// Output: [String] returns the generated NFTs link to be shared with others
  String generateEaselLinkForOpeningInPylonsApp({required String recipeId, required String cookbookId});


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
          allowedExtensions = imageAllowedExtsAndroid;
          break;
        }
        _type = FileType.image;
        break;

      case NFTTypes.video:
        _type = FileType.video;
        break;

      case NFTTypes.audio:
        if (Platform.isAndroid) {
          _type = FileType.audio;
          break;
        }
        _type = FileType.custom;
        allowedExtensions = audioAllowedExtsAndroid;
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
  bool isSvgFile(String filePath) {
    final extension = p.extension(filePath);
    return extension == ".svg";
  }

  @override
  String getExtension(String fileName) {
    return p.extension(fileName).replaceAll(".", "");
  }

  @override
  double getFileSizeInGB(int fileLength) {
    return fileLength / (1024 * 1024 * 1024).toDouble();
  }

  @override
  String getFileSizeString({required int fileLength, int precision = 2}) {
    var i = (log(fileLength) / log(1024)).floor();
    return ((fileLength / pow(1024, i)).toStringAsFixed(precision)) + suffixes[i];
  }

  @override
  String generateEaselLinkForShare({required String recipeId, required String cookbookId}) {
    return "$kWalletWebLink/?action=purchase_nft&recipe_id=$recipeId&cookbook_id=$cookbookId";
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
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9],
        uiSettings: [
          AndroidUiSettings(toolbarTitle: 'Pylons',
              toolbarColor: EaselAppTheme.kBlue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Pylons',
          ),
        ],
      );
      return croppedFile?.path ?? "";
    } catch(e){
      print(e);
      return "";
    }


  }

  @override
  String generateEaselLinkForOpeningInPylonsApp({required String recipeId, required String cookbookId}) {
    return Uri.https('pylons.page.link', "/", {
      "amv": "1",
      "apn": "tech.pylons.wallet",
      "ibi": "xyz.pylons.wallet",
      "imv": "1",
      "link": "https://wallet.pylons.tech/?action=purchase_nft&recipe_id=$recipeId&cookbook_id=$cookbookId&nft_amount=1"
    }).toString();

  }
}
