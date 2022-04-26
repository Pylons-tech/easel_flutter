import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter/material.dart';

class Model3dViewer extends StatefulWidget {
  final File file;

  const Model3dViewer({Key? key, required this.file}) : super(key: key);

  @override
  _Model3dViewerState createState() => _Model3dViewerState();
}

class _Model3dViewerState extends State<Model3dViewer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 60.h),
      child: ModelViewer(
        src: 'file://${widget.file.path}',
        ar: true,
        autoRotate: false,
        cameraControls: true,
      ),
    );
  }
}
