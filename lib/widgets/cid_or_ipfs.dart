import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';

class ShouldShowIPFS extends StatelessWidget {
  final WidgetBuilder onOther;
  final WidgetBuilder onIPFS;
  final String type;

  const ShouldShowIPFS({Key? key, required this.onOther, required this.onIPFS, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case k3dText:
      case kPdfText:
        return onOther(context);
      default:
        return onIPFS(context);
    }
  }
}
