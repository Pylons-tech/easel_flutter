import 'package:flutter/cupertino.dart';

class RightSmallBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width - (size.width * 0.2), size.height)
      ..lineTo(size.width, size.height - (size.height * 0.2))
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
