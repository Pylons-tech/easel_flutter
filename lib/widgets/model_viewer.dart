
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter/material.dart';

class Model3dViewer extends StatefulWidget {
  final bool? isFile;
  final String? path;

  const Model3dViewer({Key? key, required this.isFile, required this.path}) : super(key: key);

  @override
  _Model3dViewerState createState() => _Model3dViewerState();
}

class _Model3dViewerState extends State<Model3dViewer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 60.h),
      child: modelViewer,
    );
  }

  ModelViewer? modelViewer;

  @override
  void initState() {
    super.initState();

    modelViewer = ModelViewer(
      src: widget.isFile! ? 'file://${widget.path!}' : widget.path!,
      ar: true,
      autoRotate: false,
      cameraControls: true,
    );
  }
}
