import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter/material.dart';

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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ImageWidget(imageUrl: kImage),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mona Lisa", style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600,
                      ),),
                      const VerticalSpace(4,),
                      RichText(
                        text: TextSpan(text: "${"Created by "} ",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 20,
                            ),
                            children: const [
                              TextSpan(text: "Flowtys Studio", style: TextStyle(color: kBlue))
                            ]),
                      ),

                      Divider(height: 40, thickness: 1.2,),
                      Text("Description", style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 18,
                      ),),
                      Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                          "sed do eiusmod tempor incididunt ut labore et dolore magna "
                          "aliqua. Ut enim ad minim veniam, quis nostrud exercita",
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 14,
                      ),),
                      const VerticalSpace(10,),
                      Text("Size: 1920 x 1080px SVG",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 14,
                        ),),
                      Text("Date: 08/09/2021",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 14,
                        ),),
                      const VerticalSpace(10,),
                      Text("No of editions: 50",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 14,
                        ),),
                      Text("Royalty: 50%",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 14,
                        ),),

                      const VerticalSpace(20,),

                      Align(
                        child: PylonsButton(onPressed: (){}),
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _ImageWidget extends StatelessWidget {
  final String imageUrl;
  const _ImageWidget({
    Key? key,
    required this.imageUrl
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
        child: CachedNetworkImage(imageUrl: imageUrl,
          width: screenSize.width,
          errorWidget: (a, b, c) => Center(child: Text("Unable to load image", style: Theme.of(context).textTheme.bodyText1,)),
          height: screenSize.height * 0.3,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
