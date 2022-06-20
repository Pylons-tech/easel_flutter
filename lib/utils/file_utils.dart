import 'dart:io';
import 'dart:math';

import 'package:easel_flutter/models/nft_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'constants.dart';

class FileUtils {
  /// This function picks a file with the given [format] from device storage
  ///
  /// returns [PlatformFile] the selected file
  ///
  /// or null if aborted
  static Future<PlatformFile?> pickFile(NftFormat format) async {
    FileType _type;
    List<String>? allowedExtensions;
    switch (format.format) {
      case kImageText:
        if (Platform.isAndroid) {
          _type = FileType.custom;
          allowedExtensions = ["png", "jpg", "jpeg", "svg", "heif"];
        } else {
          _type = FileType.image;
        }
        break;
      case kVideoText:
        _type = FileType.video;
        break;
      case kAudioText:
        if (Platform.isAndroid) {
          _type = FileType.audio;
           }
        else{
          _type = FileType.custom;
          allowedExtensions = ['mp3', 'ogg', 'wav'];

        }

        break;
      default:
        _type = FileType.any;
        break;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: _type, allowedExtensions: allowedExtensions);

    if (result != null) {
      return result.files.single;
    }

    return null;
  }

  // This function will take an image, compress it and returns a file
  static Future<File?> compressAndGetFile(
    File file,
  ) async {
    var tempDirectory = await getTemporaryDirectory();

    var timeStamp = DateTime.now();

    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      '${tempDirectory.path}/$timeStamp.jpg',
      quality: 50,
    );

    return result;
  }

  /// This function checks if a file path extension svg or not
  /// input [filePath] the file path
  ///
  /// returns [true] if the filepath  has svg extension
  /// returns false for otherwise
  static bool isSvgFile(String? filePath) {
    if (filePath == null) {
      return false;
    }

    final extension = p.extension(filePath);
    return extension == ".svg";
  }

  /// returns the file extension of a given [fileName] of [filePath]
  static String getExtension(String fileName) {
    return p.extension(fileName).replaceAll(".", "");
  }

  /// converts file size from bytes to gigabytes
  static double getFileSizeInGB(int fileLength) {
    return fileLength / (1024 * 1024 * 1024).toDouble();
  }

  // formats file size to different byte units
  static String getFileSizeString({required int fileLength, int precision = 2}) {
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(fileLength) / log(1024)).floor();
    return ((fileLength / pow(1024, i)).toStringAsFixed(precision)) + suffixes[i];
  }

  static String generateEaselLink({required String recipeId, required String cookbookId}) {
    return "$kWalletWebLink/?action=purchase_nft&recipe_id=$recipeId&cookbook_id=$cookbookId";
  }
}
