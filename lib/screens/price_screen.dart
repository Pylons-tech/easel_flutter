import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easel_flutter/utils/amount_formatter.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/easel_price_input_field.dart';
import 'package:easel_flutter/widgets/easel_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../services/datasources/local_datasource.dart';
import '../widgets/pylons_button.dart';

class PriceScreen extends StatefulWidget {
  final PageController controller;

  const PriceScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final _formKey = GlobalKey<FormState>();
  var cacheManager = GetIt.I.get<LocalDataSource>();
  NFT? nft;
  String _royaltiesFieldError = '';
  String _noOfEditionsFieldError = '';
  String _priceFieldError = '';

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nft = cacheManager.getCacheDynamicType(key: "nft");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Consumer<EaselProvider>(builder: (_, provider, __) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    primary: false,
                    children: [
                      Text(
                        "is_this_free".tr(),
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(children: [
                        Expanded(
                          child: ClippedButton(
                            title: "yes".tr(),
                            bgColor: provider.isFreeDrop ? EaselAppTheme.kpurpleButtonColor : EaselAppTheme.kLightGreyColor,
                            textColor: provider.isFreeDrop ? EaselAppTheme.kWhite : EaselAppTheme.kLightBlackText,
                            onPressed: () async {
                              provider.updateIsFreeDropStatus(true);
                            },
                            cuttingHeight: 12.h,
                            isShadow: false,
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        Expanded(
                          child: ClippedButton(
                            title: "no".tr(),
                            bgColor: provider.isFreeDrop ? EaselAppTheme.kLightGreyColor : EaselAppTheme.kpurpleButtonColor,
                            textColor: provider.isFreeDrop ? EaselAppTheme.kLightBlackText : EaselAppTheme.kWhite,
                            onPressed: () async {
                              provider.updateIsFreeDropStatus(false);
                            },
                            cuttingHeight: 12.h,
                            isShadow: false,
                          ),
                        ),
                        SizedBox(
                          width: 60.w,
                        ),
                      ]),
                      Visibility(
                        visible: !provider.isFreeDrop,
                        child: Column(
                          children: [
                            VerticalSpace(20.h),
                            EaselPriceInputField(
                              key: ValueKey("${provider.selectedDenom.name}-amount"),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(kMaxPriceLength), provider.selectedDenom.getFormatter()],
                              controller: provider.priceController,
                              validator: (value) {
                                setState(() {
                                  if (value!.isEmpty) {
                                    _priceFieldError = kEnterPriceText;
                                    return;
                                  }
                                  if (double.parse(value.replaceAll(",", "")) < kMinValue) {
                                    _priceFieldError = "$kMinIsText $kMinValue";
                                    return;
                                  }
                                  _priceFieldError = '';
                                });
                                return null;
                              },
                            ),
                            _priceFieldError.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                                    child: Text(
                                      _priceFieldError,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Text(
                              kNetworkFeeWarnText,
                              style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                      VerticalSpace(20.h),
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
                          setState(() {
                            if (value!.isEmpty) {
                              _royaltiesFieldError = kEnterRoyaltyText;
                              return;
                            }
                            if (int.parse(value) > kMaxRoyalty) {
                              _royaltiesFieldError = "$kRoyaltyRangeText $kMinRoyalty-$kMaxRoyalty %";
                              return;
                            }
                            _royaltiesFieldError = '';
                          });
                          return null;
                        },
                      ),
                      _royaltiesFieldError.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                              child: Text(
                                _royaltiesFieldError,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
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
                          setState(() {
                            if (value!.isEmpty) {
                              _noOfEditionsFieldError = kEnterEditionText;
                              return;
                            }
                            if (int.parse(value.replaceAll(",", "")) < kMinValue) {
                              _noOfEditionsFieldError = "$kMinIsText $kMinValue";
                              return;
                            }
                            if (int.parse(value.replaceAll(",", "")) > kMaxEdition) {
                              _noOfEditionsFieldError = "$kMaxIsTextText $kMaxEdition";
                              return;
                            }
                            _noOfEditionsFieldError = '';
                          });
                          return null;
                        },
                      ),
                      _noOfEditionsFieldError.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                              child: Text(
                                _noOfEditionsFieldError,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      Text(
                        "${NumberFormat.decimalPattern().format(kMaxEdition)} $kMaxText",
                        style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                VerticalSpace(20.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: PylonsButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        if (_royaltiesFieldError.isEmpty && _noOfEditionsFieldError.isEmpty && _priceFieldError.isEmpty) {
                          context.read<EaselProvider>().updateNftFromPrice(nft?.id);
                          widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
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
    );
  }
}
