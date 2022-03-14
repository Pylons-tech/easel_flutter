import 'dart:io';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path/path.dart';

class ModelViewerScreen extends StatelessWidget {
  final File file;

  const ModelViewerScreen({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(basename(file.path))),
      body: ModelViewer(
        // src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        src: 'file://${file.path}',
        ar: true,
        autoRotate: true,
        cameraControls: true,
      ),
    );
  }
}
