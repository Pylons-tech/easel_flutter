import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomPaintButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String title;
  final Color bgColor;
  final Color textColor;
  final double cuttingHeight;
   bool? isShadow= true;

   CustomPaintButton({Key? key, required this.onPressed, required this.title, required this.bgColor, required this.textColor,required this.cuttingHeight, this.isShadow= true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        onPressed.call();
      },
      child:isShadow!? CustomPaint(
        painter: BoxShadowPainter(cuttingHeight: cuttingHeight),
        child: ClipPath(
          clipper: ButtonClipper(cuttingHeight: cuttingHeight),
          child: Container(
            color: bgColor,
            height: 20.h,
            // width: 200.w,
            child: Center(
                child: Text(
                  title,
                  style: TextStyle(color: textColor, fontSize: 16.sp, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      ):ClipPath(
        clipper: ButtonClipper(cuttingHeight: cuttingHeight),
        child: Container(
          color: bgColor,
          height: 35.h,
          // width: 200.w,
          child: Center(
              child: Text(
                title,
                style: TextStyle(color: textColor, fontSize: 16.sp, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              )),
        ),
      ) ,
    );
  }
}

class ButtonClipper extends CustomClipper<Path> {
  final double cuttingHeight;
  ButtonClipper({required this.cuttingHeight});
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - cuttingHeight);
    path.lineTo(cuttingHeight, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, cuttingHeight);
    path.lineTo(size.width - cuttingHeight, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BoxShadowPainter extends CustomPainter {
  final double cuttingHeight;
  BoxShadowPainter({required this.cuttingHeight});
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - cuttingHeight);
    path.lineTo(cuttingHeight, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, cuttingHeight);
    path.lineTo(size.width - cuttingHeight, 0);
    path.lineTo(0, 0);

    canvas.drawShadow(path, Colors.black45, 10.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
