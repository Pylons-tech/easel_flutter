import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../easel_provider.dart';
import '../models/denom.dart';

class EaselPriceInputField extends StatelessWidget {
  const EaselPriceInputField({Key? key, this.controller, this.validator, this.inputFormatters = const []})
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
            kPriceText,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 4.h),
        Stack(
          children: [
            ScreenResponsive(
              mobileScreen: (context) => Container(
                margin: EdgeInsets.only(top: 4.h),
                child: Image.asset(kTextFieldSingleLine, width: 1.sw, height: 40.h, fit: BoxFit.fill),
              ),
              tabletScreen: (context) => Image.asset(kTextFieldSingleLine, width: 1.sw, height: 32.h, fit: BoxFit.fill),
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
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.none,
                        inputFormatters: inputFormatters,
                        decoration: InputDecoration(
                            hintText: kHintPrice,
                            hintStyle: TextStyle(fontSize: 18.sp, color: EaselAppTheme.kGrey),
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0.h)))),
                const _CurrencyDropDown()
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _CurrencyDropDown extends StatelessWidget {
  const _CurrencyDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EaselProvider>(
        builder: (_, provider, __) => Stack(
              alignment: Alignment.center,
              children: [
                ScreenResponsive(
                  mobileScreen: (context) => Image.asset(kTextFieldButton, height: 40.h, fit: BoxFit.fill),
                  tabletScreen: (context) => Image.asset(kTextFieldButton, height: 32.h, fit: BoxFit.fill),
                ),
                DropdownButton<String>(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  value: provider.selectedDenom.symbol,
                  iconSize: 0,
                  elevation: 16,
                  underline: const SizedBox(),
                  dropdownColor: EaselAppTheme.kPurple03,
                  style: TextStyle(color: EaselAppTheme.kWhite, fontSize: 18.sp, fontWeight: FontWeight.w400),
                  onChanged: (String? data) {
                    if (data != null) {
                      final value = Denom.availableDenoms.firstWhere((denom) => denom.symbol == data);
                      provider.priceController.clear();
                      provider.setSelectedDenom(value);
                    }
                  },
                  items: Denom.availableDenoms.map((Denom value) {
                    return DropdownMenuItem<String>(
                      value: value.symbol,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Image.asset(value.icon), SizedBox(width: 15.w), Text(value.name)]),
                    );
                  }).toList(),
                ),
              ],
            ));
  }
}
