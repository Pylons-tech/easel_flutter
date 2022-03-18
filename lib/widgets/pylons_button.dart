import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PylonsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final bool showArrow;

  const PylonsButton(
      {Key? key,
      required this.btnText,
      required this.showArrow,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return /*TextButton.icon(
      onPressed: onPressed,
      icon: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Text(
          btnText,
          style: const TextStyle(color: EaselAppTheme.kWhite, fontSize: 16),
        ),
      ),
      label: const Icon(Icons.arrow_forward_ios, color: EaselAppTheme.kWhite),
      style: TextButton.styleFrom(
          backgroundColor: EaselAppTheme.kBlue,
          padding:
              const EdgeInsets.only(left: 50, right: 10, top: 10, bottom: 10),
          shadowColor: EaselAppTheme.kBlue,
          elevation: 10),
    );*/
        GestureDetector(
      child: Material(
          color: Colors.transparent,
          elevation: 10,
          child: SizedBox(
            width: 0.5.sw,
            height: 0.12.sw,
            child: Stack(
              children: [
                SvgPicture.asset("assets/images/svg/rectangular_button.svg",
                    fit: BoxFit.cover),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        btnText,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 16,
                            color: EaselAppTheme.kWhite,
                            fontWeight: FontWeight.w600),
                      ),
                      if (showArrow) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward,
                            color: EaselAppTheme.kWhite),
                      ]
                    ],
                  ),
                )
              ],
            ),
          )),
      onTap: () {
        onPressed();
      },
    );
  }
}
