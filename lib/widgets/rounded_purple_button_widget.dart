import 'package:flutter/material.dart';

class RoundedPurpleButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;

  const RoundedPurpleButtonWidget(
      {Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1212C4).withOpacity(0.6),
              offset: const Offset(0, 0),
              blurRadius: 10.0)
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
          colors: [
            Color.fromRGBO(255, 255, 255, 0.2),
            Color.fromRGBO(18, 18, 196, 0.6),
          ],
        ),
        // color: Color(0xFF1212C4),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 14.0, right: 10, bottom: 4, top: 2),
        child: Image.asset(
          icon,
        ),
      ),
    );
  }
}