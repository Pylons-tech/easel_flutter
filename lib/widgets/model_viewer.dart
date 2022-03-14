import 'dart:io';

import 'package:easel_flutter/utils/space_utils.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class ModalViewer extends StatefulWidget {
  final File file;

  const ModalViewer({Key? key, required this.file}) : super(key: key);

  @override
  _ModalViewerState createState() => _ModalViewerState();
}

class _ModalViewerState extends State<ModalViewer> {


  @override
  Widget build(BuildContext context) {
    return ModelViewer(
      src: 'file://${widget.file.path}',
      ar: true,
      autoRotate: false,
      cameraControls: true,
    );
  }


}
