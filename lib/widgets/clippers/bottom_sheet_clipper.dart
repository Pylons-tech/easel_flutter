import 'package:flutter/material.dart';

class BottomSheetClipper extends CustomClipper<Path> {
  BottomSheetClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.12);
    path.lineTo(size.width * 0.07, 0);
    path.lineTo(size.width * 0.93, 0);
    path.lineTo(size.width, size.height * 0.12);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
