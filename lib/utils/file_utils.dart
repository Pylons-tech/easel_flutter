import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// import 'package:bitmap/bitmap.dart';
import 'package:bitmap/bitmap.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileUtils {

  /// This methods picks a file (png, jpg, jpeg, svg) from device storage
  ///
  /// returns [PlatformFile] the selected file
  ///
  /// or null if aborted
  static Future<PlatformFile?> pickFile ()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['png','jpg', 'jpeg', 'svg'],
      type: FileType.custom
    );

    if (result != null) {
      //print(result.files.single.extension);
      return result.files.single;
    }
      return null;

  }


  /// This methods cheks if a file path extension svg or not
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
  
  static String getExtension(String fileName){
    return p.extension(fileName).replaceAll(".", "");
  }

  static double getFileSizeInMB(int fileLength){
    return (fileLength/(1024 * 1024)).ceilToDouble();
  }


  static Future<PlatformFile> convertSvgToPngFile(BuildContext context, PlatformFile svgFile)async{
    // String svgString = await DefaultAssetBundle.of(context).loadString(svgFile.path!);
    String svgString = await File(svgFile.path!).readAsString();
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, svgFile.name);

    // to have a nice rendering it is important to have the exact original height and width,
    // the easier way to retrieve it is directly from the svg string
    // but be careful, this is an ugly fix for a flutter_svg problem that works
    // with my images
    // String temp = svgString.substring(svgString.indexOf('height="')+8);
    // int originalHeight = int.parse(temp.substring(0, temp.indexOf('p')));
    // temp = svgString.substring(svgString.indexOf('width="')+7);
    // int originalWidth = int.parse(temp.substring(0, temp.indexOf('p')));

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    // double width = originalHeight * devicePixelRatio; // where 32 is your SVG's original width
    // double height = originalWidth * devicePixelRatio;
    double width = 1080 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 1920 * devicePixelRatio; // same thing

    // Convert to ui.Picture
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the screen DPI
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    // finally to Bitmap
    // Bitmap bitmap = Bitmap.fromHeadless(width.toInt(), height.toInt(),
    //     bytes!.buffer.asUint8List()
    // );



    // if you need to save it:
    final String appDir = (await getApplicationDocumentsDirectory()).path;
    String name = "Easel_${DateFormat("MMddyyyy_HHmmssSSS").format(DateTime.now())}.png";
    File newFile = File('$appDir/$name');

    newFile.writeAsBytesSync(bytes!.buffer.asUint8List());


   return PlatformFile(name: name, path: newFile.path, size: newFile.lengthSync(), bytes: bytes.buffer.asUint8List());
  }


}