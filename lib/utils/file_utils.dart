import 'dart:io';

import 'dart:typed_data';
import 'dart:ui' as ui;

// import 'package:bitmap/bitmap.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileUtils {
  /// This function picks a file (png, jpg, jpeg, svg) from device storage
  ///
  /// returns [PlatformFile] the selected file
  ///
  /// or null if aborted
  static Future<PlatformFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(

      allowedExtensions: ['png','jpg', 'jpeg'],
      type: FileType.custom
    );

    if (result != null) {
      //print(result.files.single.extension);
      return result.files.single;
    }
    return null;
  }

  /// This function checks if a file path extension svg or not
  /// input [filePath] the file path
  ///
  /// returns [true] if the filepath  has svg extension
  /// returns false for otherwise
  static bool isSvgFile(String? filePath){
    if(filePath == null){
      return false;
    }

    final extension = p.extension(filePath);
    return extension == ".svg";
  }

  /// returns the file extension of a given [fileName] of [filePath]
  static String getExtension(String fileName) {
    return p.extension(fileName).replaceAll(".", "");
  }


  /// converts file size from bytes to megabytes
  static double getFileSizeInMB(int fileLength){
    return (fileLength/(1024 * 1024)).ceilToDouble();
  }

}
