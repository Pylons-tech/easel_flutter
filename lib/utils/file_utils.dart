import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class FileUtils {

  /// This methods picks a file (png, jpg, jpeg, svg) from device storage
  ///
  /// returns [PlatformFile] the selected file
  ///
  /// or null if aborted
  Future<PlatformFile?> pickFile ()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['png','jpg', 'jpeg', 'svg'],
      type: FileType.custom
    );

    if (result != null) {
      print(result.files.single.extension);
      return result.files.single;
    }
      return null;

  }


  /// This methods cheks if a file path extension svg or not
  /// input [filePath] the file path
  ///
  /// returns [true] if the filepath  has svg extension
  /// returns false for otherwise
  bool isSvgFile(String filePath){
    final extension = p.extension(filePath);
    return extension == ".svg";
  }


}