import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageWidget extends StatelessWidget {
  final File file;

  const ImageWidget({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      file.readAsBytesSync(),
      width: 1.sw,
      height: 1.sh,
      fit: BoxFit.cover,
    );
  }
}
