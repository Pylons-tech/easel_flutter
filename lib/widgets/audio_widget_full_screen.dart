import 'dart:io';

import 'package:flutter/material.dart';

class AudioWidgetFullScreen extends StatelessWidget {
  final File? thumbnail;

  const AudioWidgetFullScreen({Key? key, this.thumbnail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: "preview_full_screen",
        child: Container(
          color: Colors.yellow,
          width: double.infinity,
          height: double.infinity,
          child: thumbnail != null ? Image.file(thumbnail!) : const SizedBox(),
        ),
      ),
    );
  }
}
