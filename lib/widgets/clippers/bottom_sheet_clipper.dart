import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetClipperDialog extends CustomClipper<Path> {
  BottomSheetClipperDialog();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.08.h);
    path.lineTo(size.width * 0.045.w, 0);
    path.lineTo(size.width * 0.88.w, 0);
    path.lineTo(size.width, size.height * 0.08.h);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BottomSheetClipper extends CustomClipper<Path> {
  BottomSheetClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.08.h);
    path.lineTo(size.width * 0.05.w, 0);
    path.lineTo(size.width * 0.95.w, 0);
    path.lineTo(size.width, size.height * 0.08.h);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
