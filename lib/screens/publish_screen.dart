import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/rounded_purple_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PublishScreen extends StatelessWidget {
  final PageController controller;

  PublishScreen({Key? key, required this.controller}) : super(key: key);

  final List<String> detailInfo = const [
    'Contract Address',
    'Token ID',
    'Token Standard',
    'Blockchain',
    'Metadata',
    'Permission'
  ];
  final List<String> sampleData = const [
    '0x495f...7b5e',
    '8416676683197945...',
    'ERC-1155',
    'Ethereum',
    'Centralized',
    'Exclusive'
  ];

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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      const ImageWidget(imageUrl: kImage),
                      Positioned(
                          top: 48,
                          right: 10,
                          child: RoundedPurpleButtonWidget(
                            onPressed: () {
                              print("here");
                              provider.shareNFT();
                            },
                            icon: 'assets/icons/share_ic.png',
                          )),
                      Positioned(
                          top: 114,
                          right: 10,
                          child: RoundedPurpleButtonWidget(
                            onPressed: () {},
                            icon: 'assets/icons/save_ic.png',
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
                              text: "Created by ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontSize: 20,
                                  ),
                              children: [
                                TextSpan(
                                    text: provider.artistNameController.text,
                                    style: const TextStyle(color: EaselAppTheme.kBlue))
                              ]),
                        ),
                        const Divider(
                          height: 40,
                          thickness: 1.2,
                        ),
                        Text(
                          "Description",
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 18,
                                  ),
                        ),
                        Text(
                        provider.descriptionController.text,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        const VerticalSpace(
                          10,
                        ),
                        Text(
                          "Size: 1920 x 1080px ${provider.fileExtension.toUpperCase()}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        Text(
                          "Date: ${DateFormat.yMd('en_US').format(DateTime.now())}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        const VerticalSpace(
                          10,
                        ),
                        Text(
                          "No of editions: ${provider.noOfEditionController.text}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        Text(
                          "Royalty: ${provider.royaltyController.text}%",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        const Divider(
                          height: 40,
                          thickness: 1.2,
                        ),
                        Text(
                          "Details",
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 18,
                                  ),
                        ),
                        Column(
                          children: List.generate(detailInfo.length, (i) {
                            return _buildDetailInfo(
                              context: context,
                              text: sampleData[i],
                              title: detailInfo[i],
                            );
                          }),
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

  Widget _buildDetailInfo(
      {required BuildContext context,
      required String title,
      required String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 14,
                ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 14,
                ),
          )
        ],
      ),
    );
  }
}
