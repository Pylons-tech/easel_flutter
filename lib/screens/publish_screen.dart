import 'dart:developer';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/date_utils.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/rounded_purple_button_widget.dart';
import 'package:easel_flutter/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublishScreen extends StatefulWidget {
  final PageController controller;

  const PublishScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {

  late EaselProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EaselProvider>(context);
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        if (provider.nftFormat.format == kImageText) ...[
                          ImageWidget(file: provider.file!)
                        ],
                        if (provider.nftFormat.format == kVideoText) ...[
                          VideoWidget(file: provider.file!, previewFlag: true,)
                        ],
                        if (provider.nftFormat.format == kAudioText) ...[
                          AudioWidget(file: provider.file!)
                        ],
                        Positioned(
                            top: 60,
                            right: 10,
                            child: RoundedPurpleButtonWidget(
                              onPressed: () {
                                final Size size = MediaQuery.of(context).size;

                                provider.shareNFT(size);
                              },
                              icon: kShareIcon,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.artNameController.text,
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          const VerticalSpace(
                            4,
                          ),
                          RichText(
                            text: TextSpan(
                                text: "$kCreatedByText ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                                children: [
                                  TextSpan(
                                      text: provider.artistNameController.text,
                                      style: const TextStyle(
                                          color: EaselAppTheme.kBlue))
                                ]),
                          ),
                          const Divider(
                            height: 40,
                            thickness: 1.2,
                          ),
                          Text(
                            kNftDetailsText,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 18,
                                    ),
                          ),
                          Text(
                            provider.descriptionController.text,
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                          const VerticalSpace(
                            10,
                          ),
                          Text(
                            "$kPriceText: ${provider.priceController.text.trim()} ${provider.selectedDenom.name}",
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                          if (provider.nftFormat.format != kAudioText) ...[
                            Text(
                              "$kSizeText: ${provider.fileWidth} x ${provider.fileHeight}px ${provider.fileExtension.toUpperCase()}",
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontSize: 14,
                                      ),
                            )
                          ],
                          if (provider.nftFormat.format == kVideoText ||
                              provider.nftFormat.format == kAudioText) ...[
                            Text(
                              "$kDurationText: ${provider.fileDuration / kSecInMillis} sec",
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontSize: 14,
                                      ),
                            )
                          ],
                          Text(
                            "$kDateText: ${getDate()}",
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                          const VerticalSpace(
                            10,
                          ),
                          Text(
                            "$kNoOfEditionText: ${provider.noOfEditionController.text}",
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                          Text(
                            "$kRoyaltyText: ${provider.royaltyController.text}%",
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
