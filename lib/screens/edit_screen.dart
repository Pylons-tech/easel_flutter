import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/denom.dart';
import 'package:easel_flutter/utils/amount_formatter.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/easel_text_field.dart';
import 'package:easel_flutter/widgets/pylons_round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final PageController controller;

  const EditScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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
      body: Stack(
        children: [
          const Positioned(
            bottom: 0,
            right: 0,
            child: BackgroundWidget(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Consumer<EaselProvider>(builder: (_, provider, __) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EaselTextField(
                        title: kNameAsArtistText,
                        controller: provider.artistNameController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) return kEnterArtistNameText;
                          return null;
                        },
                      ),
                      const VerticalSpace(20),
                      EaselTextField(
                        title: kGiveNFTNameText,
                        controller: provider.artNameController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kEnterNFTNameText;
                          }
                          if (value.length <= kMinNFTName) {
                            return "$kNameShouldHaveText $kMinNFTName $kCharactersOrMoreText";
                          }
                          return null;
                        },
                      ),
                      const VerticalSpace(20),
                      EaselTextField(
                        title: kDescribeNFTText,
                        noOfLines: 4,
                        controller: provider.descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        inputFormatters: [LengthLimitingTextInputFormatter(kMaxDescription)],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kEnterNFTDescriptionText;
                          }
                          if (value.length <= kMinDescription) {
                            return "$kEnterMoreThanText $kMinDescription $kCharactersText";
                          }
                          return null;
                        },
                      ),
                      const VerticalSpace(4),
                      Text(
                        "$kMaxDescription $kCharacterLimitText",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: EaselAppTheme.kGrey, fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace(20),
                      EaselTextField(
                        key: ValueKey("${provider.selectedDenom.name}-amount"),
                        title: kPriceText,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(kMaxPriceLength), provider.selectedDenom.getFormatter()],
                        controller: provider.priceController,
                        suffix: const _CurrencyDropDown(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kEnterPriceText;
                          }

                          if (double.parse(value.replaceAll(",", "")) < kMinValue) return "$kMinIsText $kMinValue";

                          return null;
                        },
                      ),
                      const VerticalSpace(20),
                      EaselTextField(
                        key: ValueKey(provider.selectedDenom.name),
                        title: "$kNoOfEditionText ($kMaxText: $kMaxEdition)",
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
                      const VerticalSpace(20),
                      EaselTextField(
                        title: kRoyaltiesText,
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
                      const VerticalSpace(4),
                      Text(
                        "$kRoyaltyNoteText “$kMinRoyalty”",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: EaselAppTheme.kGrey, fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace(20),
                      Align(
                        child: PylonsRoundButton(onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                          }
                        }),
                      ),
                      const VerticalSpace(20),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyDropDown extends StatelessWidget {
  const _CurrencyDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EaselProvider>(
      builder: (_, provider, __) => DropdownButton<String>(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        value: provider.selectedDenom.symbol,
        icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: EaselAppTheme.kBlue),
        iconSize: 30,
        elevation: 16,
        underline: const SizedBox(),
        focusColor: EaselAppTheme.kBlue,
        dropdownColor: EaselAppTheme.kWhite,
        style: const TextStyle(color: EaselAppTheme.kBlack, fontSize: 16, fontWeight: FontWeight.w500),
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
            child: Text(value.name),
          );
        }).toList(),
      ),
    );
  }
}
