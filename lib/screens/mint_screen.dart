import 'dart:developer';
import 'dart:io';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class MintScreen extends StatelessWidget {
  final PageController controller;
  const MintScreen({Key? key, required this.controller}) : super(key: key);

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

          Consumer<EaselProvider>(
            builder: (_, provider, __) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageWidget(file: provider.file!),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(provider.artNameController.text, style: Theme.of(context).textTheme.headline5!.copyWith(
                           color: EaselAppTheme.kDarkText, fontWeight: FontWeight.w600,
                        ),),
                        const VerticalSpace(4,),
                        RichText(
                          text: TextSpan(text: "${"Created by "} ",
                              style: GoogleFonts.inter(
                                  textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 20, color: EaselAppTheme.kDarkText,
                                  )
                              ),
                              children: [
                                TextSpan(text: provider.artistNameController.text, style: const TextStyle(color: EaselAppTheme.kBlue))
                              ]),
                        ),

                        const Divider(height: 40, thickness: 1.2,),
                        Text("Description", style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 18,
                        ),),
                        Text(provider.descriptionController.text,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 14, color: EaselAppTheme.kLightText, fontWeight: FontWeight.w300
                        ),),
                        const VerticalSpace(10,),
                        Text("Size: ${provider.fileWidth} x ${provider.fileHeight}px ${provider.fileExtension.toUpperCase()}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 14,
                          ),),
                        Text("Date: ${DateFormat.yMd('en_US').format(DateTime.now())}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 14,
                          ),),
                        const VerticalSpace(10,),
                        Text("No of editions: ${provider.noOfEditionController.text}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 14,
                          ),),
                        Text("Royalty: ${provider.royaltyController.text}%",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 14,
                          ),),

                        const VerticalSpace(20,),

                        Align(
                          child: PylonsButton(onPressed: ()async{

                              bool isRecipeCreated = await provider.createRecipe();
                              log("Recipe created: $isRecipeCreated");

                              if(!isRecipeCreated){
                                return;
                              }

                            controller.jumpToPage(3);
                            // provider.initStore();
                          }),
                        ),
                        const VerticalSpace(20,),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}


