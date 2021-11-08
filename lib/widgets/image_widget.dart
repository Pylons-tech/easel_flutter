import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final File file;
  const ImageWidget({
    Key? key,
    required this.file
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
        child: Image.memory(file.readAsBytesSync(),
          width: screenSize.width,
          height: screenSize.height * 0.3,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
