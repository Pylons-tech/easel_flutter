import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../easel_provider.dart';

class EaselHashtagInputField extends StatefulWidget {
  const EaselHashtagInputField({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HashtagInputFieldState();
  }
}

class _HashtagInputFieldState extends State<EaselHashtagInputField> {
  final _inputController = TextEditingController();
  late final ValueNotifier<List<String>> _hashtagsNotifier;

  @override
  void initState() {
    super.initState();

    _hashtagsNotifier = ValueNotifier(context.read<EaselProvider>().hashtagsList);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EaselProvider>(
      builder: (_, provider, __) => Column(
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
          Stack(children: [
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
                        controller: _inputController,
                        minLines: 1,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
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
                        setState(() {
                          var trimmed = _inputController.text.trim();
                          trimmed = trimmed.replaceAll('#', '');
                          if (!_hashtagsNotifier.value.contains(trimmed)) {
                            _hashtagsNotifier.value.add(trimmed);
                          }
                        });
                      },
                      child: Text(kAddText,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kWhite)),
                    ),
                  ],
                )
              ],
            )
          ]),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _hashtagsNotifier.value
                      .map((hashtag) => Row(
                            children: [
                              Text('#' + hashtag,
                                  style: TextStyle(
                                      fontSize: 14.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kGrey)),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hashtagsNotifier.value.remove(hashtag);
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: EaselAppTheme.kLightGrey,
                                ),
                              ),
                              SizedBox(width: 10.w)
                            ],
                          ))
                      .toList(),
                ),
              ))
        ],
      ),
    );
  }
}
