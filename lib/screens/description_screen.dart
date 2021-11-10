import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/amount_formatter.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/easel_text_field.dart';
import 'package:easel_flutter/widgets/pylons_round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DescriptionScreen extends StatefulWidget {
  final PageController controller;
  const DescriptionScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
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
              child: Consumer<EaselProvider>(
                builder: (_, provider, __) => Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EaselTextField(
                        title: "Your name as the artist",
                        controller: provider.artistNameController,
                        validator: (value) {
                          if (value!.isEmpty) return "Enter artist name";
                          return null;
                        },
                      ),
                      const VerticalSpace(
                        20,
                      ),
                      EaselTextField(
                        title: "Give your NFT a name",
                        controller: provider.artNameController,
                        validator: (value) {
                          if (value!.isEmpty) return "Enter NFT name";
                          return null;
                        },
                      ),
                      const VerticalSpace(
                        20,
                      ),
                      EaselTextField(
                        title: "Describe your NFT",
                        noOfLines: 4,
                        controller: provider.descriptionController,

                        inputFormatters: [LengthLimitingTextInputFormatter(kMaxDescription)],
                        validator: (value){
                          if(value!.isEmpty) return "Enter NFT description";
                          if(value.length <= kMinDescription) return "Enter more than $kMinDescription characters";
                          return null;
                        },
                      ),
                      const VerticalSpace(4),
                      Text(
                        "$kMaxDescription character limit",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: EaselAppTheme.kGrey,
                            fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace(
                        20,
                      ),
                      EaselTextField(
                        title: "Price (Pylons)",
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(kMaxPriceLength),
                          AmountFormatter(maxDigits: kMaxPriceLength)
                        ],
                        controller: provider.priceController,
                        validator: (value){
                          if(value!.isEmpty) return "Enter price";
                          if(int.parse(value.replaceAll(",", "")) < kMinValue) return "Minimum amount is $kMinValue";
                          return null;
                        },
                      ),
                      const VerticalSpace(
                        20,
                      ),
                      EaselTextField(
                        title: "Number of Editions (Max: $kMaxEdition)",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                          AmountFormatter(maxDigits: 5)
                        ],
                        controller: provider.noOfEditionController,
                        validator: (value){
                          if(value!.isEmpty) return "Enter number of editions";
                          if(int.parse(value.replaceAll(",", "")) < kMinValue) return "Minimum is $kMinValue";
                          if(int.parse(value.replaceAll(",", "")) > kMaxEdition) return "Maximum is $kMaxEdition";

                          return null;
                        },
                      ),
                      const VerticalSpace(
                        20,
                      ),
                      EaselTextField(
                        title: "Royalties (%)",
                        hint: "10%",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2)
                        ],
                        controller: provider.royaltyController,
                        validator: (value) {
                          if (value!.isEmpty)return "Enter royalty in percentage";
                          if (int.parse(value) > kMaxRoyalty) return "Allowed royalty is between $kMinRoyalty-$kMaxRoyalty %";
                          return null;
                        },
                      ),
                      const VerticalSpace(
                        4,
                      ),
                      Text(
                        "Pecentage of all secondary market sales automatically distributed to the creator.\n"
                        "To opt out set value to “$kMinRoyalty”",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: EaselAppTheme.kGrey,
                            fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace(
                        20,
                      ),
                      Align(
                        child: PylonsRoundButton(onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            // print(controller.page!);
                            final currentPage = widget.controller.page!;
                            double nextPage = currentPage < 3.0 ? (currentPage + 1) : 3;
                            // print(xx);
                            widget.controller.jumpToPage(nextPage.toInt());
                          }
                        }),
                      ),
                      const VerticalSpace(
                        20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
