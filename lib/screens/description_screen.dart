import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/easel_text_field.dart';
import 'package:easel_flutter/widgets/pylons_round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptionScreen extends StatelessWidget {
  final PageController controller;
  const DescriptionScreen({Key? key, required this.controller}) : super(key: key);

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
              child: Column(
                children: [
                  EaselTextField(title: "Your name as the artist",),
                  const VerticalSpace(20,),
                  EaselTextField(title: "Give your NFT a name",),
                  const VerticalSpace(20,),
                  EaselTextField(title: "Describe your NFT", noOfLines: 4,),
                  const VerticalSpace(20,),
                  EaselTextField(title: "Number of Edition (Max: 100)",
                    keyboardType: TextInputType.number,),
                  const VerticalSpace(20,),
                  EaselTextField(title: "Royalties", hint: "10%",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),),
                  const VerticalSpace(20,),
                  PylonsRoundButton(onPressed: (){
                    print(controller.page!);
                    final yy = controller.page!;
                    double xx = yy < 3.0 ? (yy + 1) : 3;
                    print(xx);
                    controller.jumpToPage(xx.toInt());
                  }),
                  const VerticalSpace(20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


