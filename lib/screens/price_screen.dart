import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/amount_formatter.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/easel_price_input_field.dart';
import 'package:easel_flutter/widgets/easel_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/pylons_button.dart';

class PriceScreen extends StatefulWidget {
  final PageController controller;

  const PriceScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final _formKey = GlobalKey<FormState>();

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
                  Align(
                    alignment: Alignment.center,
                    child: Text(kPriceNoticeText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 14.sp, color: EaselAppTheme.kLightPurple, fontWeight: FontWeight.w400)),
                  ),
                  VerticalSpace(20.h),
                  EaselPriceInputField(
                    key: ValueKey("${provider.selectedDenom.name}-amount"),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(kMaxPriceLength),
                      provider.selectedDenom.getFormatter()
                    ],
                    controller: provider.priceController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return kEnterPriceText;
                      }

                      if (double.parse(value.replaceAll(",", "")) < kMinValue) return "$kMinIsText $kMinValue";

                      return null;
                    },
                  ),
                  Text(
                    kNetworkFeeWarnText,
                    style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                  ),

                  const VerticalSpace(20),
                  EaselTextField(
                    label: kRoyaltiesText,
                    hint: kRoyaltyHintText,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                      AmountFormatter(
                        maxDigits: 2,
                      )
                    ],
                    controller: provider.royaltyController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return kEnterRoyaltyText;
                      }
                      if (int.parse(value) > kMaxRoyalty) {
                        return "$kRoyaltyRangeText $kMinRoyalty-$kMaxRoyalty %";
                      }
                      return null;
                    },
                  ),
                  Text(
                    "$kRoyaltyNoteText “$kMinRoyalty”.",
                    style: TextStyle(color: EaselAppTheme.kLightPurple, fontWeight: FontWeight.w800, fontSize: 14.sp),
                  ),

                  VerticalSpace(20.h),
                  EaselTextField(
                    key: ValueKey(provider.selectedDenom.name),
                    label: kNoOfEditionText,
                    hint: kHintNoEdition,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                      AmountFormatter(
                        maxDigits: 5,
                      )
                    ],
                    controller: provider.noOfEditionController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return kEnterEditionText;
                      }
                      if (int.parse(value.replaceAll(",", "")) < kMinValue) {
                        return "$kMinIsText $kMinValue";
                      }
                      if (int.parse(value.replaceAll(",", "")) > kMaxEdition) {
                        return "$kMaxIsTextText $kMaxEdition";
                      }

                      return null;
                    },
                  ),
                  Text(
                    "${NumberFormat.decimalPattern('hi').format(kMaxEdition)} $kMaxText",
                    style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                  ),


                  VerticalSpace(40.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PylonsButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        }
                      },
                      btnText: kContinue,
                      showArrow: true,
                      isBlue: false,
                    ),
                  ),
                  const VerticalSpace(20),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
