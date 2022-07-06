import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageWidget extends StatelessWidget {
  final File? file;
  final String? filePath;

  const ImageWidget({Key? key, this.file, this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return file != null
        ? Image.memory(
            file!.readAsBytesSync(),
            width: 1.sw,
            height: 1.sh,
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: filePath!,
            errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
            placeholder: (context, url) => Center(
              child: SizedBox(height: 30.h, width: 30.h, child: const CircularProgressIndicator()),
            ),
          );
  }
}
