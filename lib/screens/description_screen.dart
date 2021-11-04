import 'package:easel_flutter/easel_provider.dart';
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

class DescriptionScreen extends StatelessWidget {
  final PageController controller;
  const DescriptionScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  key: provider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EaselTextField(
                        title: "Your name as the artist",
                        controller: provider.artistNameController,
                        validator: (value){
                          if(value!.isEmpty) return "Enter artist name";
                          return null;
                        },
                      ),
                      const VerticalSpace(
                        20,
                      ),
                      EaselTextField(
                        title: "Give your NFT a name",
                        controller: provider.artNameController,
                        validator: (value){
                          if(value!.isEmpty) return "Enter NFT name";
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
                        inputFormatters: [LengthLimitingTextInputFormatter(256)],
                        validator: (value){
                          if(value!.isEmpty) return "Enter NFT description";
                          if(value.length < 10) return "Enter at least 10 characters";
                          return null;
                        },
                      ),
                      const VerticalSpace(4),
                      Text(
                        "256 character limit",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: EaselAppTheme.kGrey, fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace(
                        20,
                      ),
                      EaselTextField(
                        title: "Number of Editions (Max: 10,000)",
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5)],
                        controller: provider.noOfEditionController,
                        validator: (value){
                          if(value!.isEmpty) return "Number of Editions";
                          if(int.parse(value) > 10000) return "Maximum is 10,000";
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
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2)],
                        controller: provider.royaltyController,
                        validator: (value){
                          if(value!.isEmpty) return "Enter royalty in percentage";
                          if(int.parse(value) >= 100) return "Allowed royalty is between 0-99 %";
                          return null;
                        },
                      ),
                      const VerticalSpace(
                        4,
                      ),
                      Text(
                        "Pecentage of all secondary market sales automatically distributed to the creator.\n"
                        "To opt out set value to “0”",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: EaselAppTheme.kGrey, fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace(
                        20,
                      ),
                      Align(
                        child: PylonsRoundButton(onPressed: () {
                          FocusScope.of(context).unfocus();
                          if(provider.formKey.currentState!.validate()){
                            // print(controller.page!);
                            final yy = controller.page!;
                            double xx = yy < 3.0 ? (yy + 1) : 3;
                            // print(xx);
                            controller.jumpToPage(xx.toInt());
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
