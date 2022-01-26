import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import 'constants.dart';

class FileUtils {
  /// This function picks a file (png, jpg, jpeg, svg) from device storage
  ///
  /// returns [PlatformFile] the selected file
  ///
  /// or null if aborted
  static Future<PlatformFile?> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      return result.files.single;
    }
    return null;
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
    return (fileLength / (1024 * 1024 * 1024)).ceilToDouble();
  }

  // formats file size to different byte units
  static String getFileSizeString(
      {required int fileLength, int precision = 2}) {
    const suffixes = ["b", "kb", "MB", "GB", "TB"];
    var i = (log(fileLength) / log(1024)).floor();
    return ((fileLength / pow(1024, i)).toStringAsFixed(precision)) +
        suffixes[i];
  }

  static String generateEaselLink({required String recipeId, required String cookbookId}) {
    return Uri.https(kWalletDynamicLink, "/", {
      "amv": "1",
      "apn": kWalletAndroidId,
      "ibi": kWalletIOSId,
      "imv": "1",
      "link": "$kWalletWebLink/?action=purchase_nft&recipe_id=$recipeId&cookbook_id=$cookbookId&nft_amount=1"
    }).toString();
  }



}
