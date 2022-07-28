import 'package:auto_size_text/auto_size_text.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easel_flutter/main.dart';

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
          Text(
            kHashtagsText,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Stack(children: [
            Image.asset(
              kTextFieldSingleLine,
              height: isTablet ? 32.h : 40.h,
              width: 1.sw,
              fit: BoxFit.fill,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: SizedBox(
                        height: isTablet ? 32.h : 40.h,
                        child: Align(
                            alignment: Alignment.center,
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: isTablet ?  16.sp: 18.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kDarkText),
                              controller: _inputController,
                              minLines: 1,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                  hintText: kHintHashtag,
                                  hintStyle: TextStyle(fontSize: isTablet ? 16.sp : 18.sp, color: EaselAppTheme.kGrey),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  contentPadding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),),inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp(r'\s')),
                            ],
                            )))),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(kTextFieldButton, height: isTablet ? 32.h : 40.h, fit: BoxFit.fill),
                    SizedBox(
                      height: isTablet ? 32.h : 40.h,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            var trimmed = _inputController.text.trim();
                            trimmed = trimmed.replaceAll('#', '');
                            if (trimmed.isNotEmpty && !_hashtagsNotifier.value.contains(trimmed)) {
                              _hashtagsNotifier.value.add(trimmed);
                            }
                            _inputController.clear();
                          });
                        },
                        child: AutoSizeText(kAddText,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kWhite)),
                      ),
                    )
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
