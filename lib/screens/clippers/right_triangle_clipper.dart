import 'package:flutter/material.dart';
enum Orientation {
  Orientation_SE,
  Orientation_NE,
  Orientation_NW,
  Orientation_SW,
}
class RightTriangleClipper extends CustomClipper<Path> {
  final Orientation orientation;

  RightTriangleClipper({required this.orientation});

  @override
  Path getClip(Size size) {
    final path = Path();

    switch (orientation) {
      case Orientation.Orientation_SW:
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, 0);
        break;
      case Orientation.Orientation_SE:
        path.lineTo(0, size.height);
        path.lineTo(size.width, 0);
        break;
      case Orientation.Orientation_NW:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
      case Orientation.Orientation_NE:
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}