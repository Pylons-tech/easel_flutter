import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/easel_hashtag_input_field.dart';
import 'package:easel_flutter/widgets/easel_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widgets/pylons_button.dart';

class DescribeScreen extends StatefulWidget {
  final PageController controller;

  const DescribeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<DescribeScreen> createState() => _DescribeScreenState();
}

class _DescribeScreenState extends State<DescribeScreen> {
  final _formKey = GlobalKey<FormState>();

  String _artNameFieldError = '';
  String _artistNameFieldError = '';
  String _descriptionFieldError = '';

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<EaselProvider>().artistNameController.text = context.read<EaselProvider>().currentUsername;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Consumer<EaselProvider>(builder: (_, provider, __) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpace(10.h),
                  EaselTextField(
                    label: kGiveNFTNameText,
                    hint: kHintNftName,
                    controller: provider.artNameController,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      setState(() {
                        if (value!.isEmpty) {
                          _artNameFieldError = kEnterNFTNameText;
                          return;
                        }
                        if (value.length <= kMinNFTName) {
                          _artNameFieldError = "$kNameShouldHaveText $kMinNFTName $kCharactersOrMoreText";
                          return;
                        }
                        _artNameFieldError = '';
                      });
                      return null;
                    },
                  ),
                  _artNameFieldError.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                          child: Text(
                            _artNameFieldError,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  VerticalSpace(20.h),
                  EaselTextField(
                    label: kNameAsArtistText,
                    hint: kHintArtistName,
                    controller: provider.artistNameController,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      setState(() {
                        if (value!.isEmpty) {
                          _artistNameFieldError = kEnterArtistNameText;
                        } else {
                          _artistNameFieldError = '';
                        }
                      });
                      return null;
                    },
                  ),
                  _artistNameFieldError.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                          child: Text(
                            _artistNameFieldError,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  VerticalSpace(20.h),
                  EaselTextField(
                    label: kDescribeYourNftText,
                    hint: kHintNftDesc,
                    noOfLines: 5,
                    controller: provider.descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [LengthLimitingTextInputFormatter(kMaxDescription)],
                    validator: (value) {
                      setState(() {
                        if (value!.isEmpty) {
                          _descriptionFieldError = kEnterNFTDescriptionText;
                          return;
                        }
                        if (value.length <= kMinDescription) {
                          _descriptionFieldError = "$kEnterMoreThanText $kMinDescription $kCharactersText";
                          return;
                        }
                        _descriptionFieldError = '';
                      });
                      return null;
                    },
                  ),
                  _descriptionFieldError.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                          child: Text(
                            _descriptionFieldError,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Text(
                    "$kMaxDescription $kCharacterLimitText",
                    style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                  ),
                  VerticalSpace(20.h),
                  const EaselHashtagInputField(),
                  VerticalSpace(40.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PylonsButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (_artNameFieldError.isEmpty &&
                              _artistNameFieldError.isEmpty &&
                              _descriptionFieldError.isEmpty) {
                            widget.controller
                                .nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                          }
                        }
                      },
                      btnText: kContinue,
                      showArrow: true,
                      isBlue: false,
                    ),
                  ),
                  VerticalSpace(20.h),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}