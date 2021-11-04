import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MintScreen extends StatelessWidget {
  final PageController controller;
  MintScreen({Key? key, required this.controller}) : super(key: key);

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
                  _ImageWidget(file: provider.file!),
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
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontSize: 20, color: EaselAppTheme.kDarkText, fontFamily: "Inter"
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
                        Text("Size: 1920 x 1080px ${provider.fileExtension.toUpperCase()}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 14,
                          ),),
                        Text("Date: ${DateTime.now().toString()}",
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
                          child: PylonsButton(onPressed: (){
                            controller.jumpToPage(0);
                            provider.initStore();
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



class _ImageWidget extends StatelessWidget {
  final File file;
  const _ImageWidget({
    Key? key,
    required this.file
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
        child: Image.memory(file.readAsBytesSync(),
          width: screenSize.width,
          height: screenSize.height * 0.3,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
