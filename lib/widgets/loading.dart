import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:flutter/material.dart';

class Loading {
  Loading();

  void dismiss() {
    navigatorKey.currentState!.pop();
  }

  Loading showLoading({String message = "Loading..."}) {
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: true,
      builder: (ctx) =>
          AlertDialog(
            content: Wrap(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                    const HorizontalSpace(10),
                    Text(
                      message,
                      style:
                      Theme
                          .of(ctx)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
    );
    return this;
  }
}