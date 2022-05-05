import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EaselHashtagInputField extends StatelessWidget {
  const EaselHashtagInputField({Key? key, this.controller, this.validator, this.inputFormatters = const []})
      : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 22.h,
          child: Text(
            kHashtagsText,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.5.h),
              child: SvgPicture.asset(kSvgTextHalfFieldBG),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: TextFormField(
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kDarkText),
                        controller: controller,
                        validator: validator,
                        minLines: 1,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        inputFormatters: inputFormatters,
                        decoration: InputDecoration(
                            hintText: kHintHashtag,
                            hintStyle: TextStyle(fontSize: 18.sp, color: EaselAppTheme.kGrey),
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 0.h)))),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(kSvgButtonLightPurple),
                    TextButton(
                      onPressed: () {

                      },
                      child: Text(kAddText,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kWhite)),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
