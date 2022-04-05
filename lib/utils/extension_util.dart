import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScaffoldHelper on BuildContext? {
  void show({required String message}) {
    if (this == null) {
      return;
    }

    ScaffoldMessenger.maybeOf(this!)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        duration: const Duration(seconds: 2),
      ));
  }
}
