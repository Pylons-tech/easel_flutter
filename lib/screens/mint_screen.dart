import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/date_utils.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/model_viewer.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:easel_flutter/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../repository/repository.dart';

class MintScreen extends StatefulWidget {
  final PageController controller;

  const MintScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<MintScreen> createState() => _MintScreenState();
}

class _MintScreenState extends State<MintScreen> {
  late NFT nft;
  var repository = GetIt.I.get<Repository>();

  @override
  initState() {
    nft = repository.getCacheDynamicType(key: "nft");
    super.initState();
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
          Consumer<EaselProvider>(
            builder: (_, provider, __) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (provider.nftFormat.format == kImageText) ...[
                    ImageWidget(
                      file: provider.file,
                      filePath: nft.url,
                    )
                  ],
                  if (provider.nftFormat.format == kVideoText) ...[
                    VideoWidget(
                      file: provider.file!,
                      previewFlag: true,
                      isForFile: true,
                    )
                  ],
                  if (provider.nftFormat.format == k3dText) ...[
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Model3dViewer(
                          file: provider.file!,
                        ))
                  ],
                  if (provider.nftFormat.format == kAudioText) ...[
                    AudioWidget(
                      file: provider.file!,
                      previewFlag: true,
                    )
                  ],
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.artNameController.text,
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                                color: EaselAppTheme.kDarkText,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const VerticalSpace(
                          4,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "$kCreatedByText ",
                              style: GoogleFonts.inter(
                                  textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                                        fontSize: 20,
                                        color: EaselAppTheme.kDarkText,
                                      )),
                              children: [TextSpan(text: provider.artistNameController.text, style: const TextStyle(color: EaselAppTheme.kBlue))]),
                        ),
                        const Divider(
                          height: 40,
                          thickness: 1.2,
                        ),
                        Text(
                          kNftDetailsText,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 18,
                              ),
                        ),
                        Text(
                          provider.descriptionController.text,
                          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14, color: EaselAppTheme.kLightText, fontWeight: FontWeight.w300),
                        ),
                        const VerticalSpace(
                          10,
                        ),
                        Text(
                          "$kPriceText: ${provider.priceController.text.trim()} ${provider.selectedDenom.name}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        if (provider.nftFormat.format != kAudioText) ...[
                          Text(
                            "$kSizeText: ${provider.fileWidth} x ${provider.fileHeight}px ${provider.fileExtension.toUpperCase()}",
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontSize: 14,
                                ),
                          )
                        ],
                        if (provider.nftFormat.format == kVideoText || provider.nftFormat.format == kAudioText) ...[
                          Text(
                            "$kDurationText: ${provider.fileDuration / kSecInMillis} sec",
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontSize: 14,
                                ),
                          )
                        ],
                        Text(
                          "$kDateText: ${getDate()}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        const VerticalSpace(
                          10,
                        ),
                        Text(
                          "$kNoOfEditionText: ${provider.noOfEditionController.text}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        Text(
                          "$kRoyaltyText: ${provider.royaltyController.text}%",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        const VerticalSpace(
                          20,
                        ),
                        Align(
                          child: PylonsButton(
                            onPressed: () async {
                              bool isRecipeCreated = await provider.createRecipe(nft);
                              if (!isRecipeCreated) {
                                return;
                              }
                              provider.disposeAudioController();
                              Navigator.of(context).popUntil(ModalRoute.withName(RouteUtil.ROUTE_CREATOR_HUB));


                            },
                            btnText: kListText,
                            showArrow: true,
                          ),
                        ),
                        const VerticalSpace(
                          20,
                        ),
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
