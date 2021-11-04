import 'dart:ui';

import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_size_util.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/widgets/pylons_round_button.dart';
import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  final PageController controller;
  UploadScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  bool showError = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _UploadWidget(),

                    PylonsRoundButton(onPressed: (){
                      widget.controller.jumpToPage(1);
                    }),

                  ],
                ),
              ),
              const SizedBox(height: 20)
            ]
          ),
          Positioned(
            child: Visibility(
              visible: showError,
              child: _ErrorMessageWidget(
                onClose: (){
                  setState(() {
                    showError = false;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _UploadWidget extends StatelessWidget {
  const _UploadWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Upload", style: Theme.of(context).textTheme.headline5!.copyWith(
          fontWeight: FontWeight.w600
        ),),
        const VerticalSpace(5),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.5,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(70),
          decoration: BoxDecoration(
            color: EaselAppTheme.kBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: NetworkImage(kImage),
              fit: BoxFit.fill
            )
          ),
          child: Image.asset("assets/icons/file.png",),
        ),
        const VerticalSpace(5),
        Text("SVG file", style: Theme.of(context).textTheme.subtitle2!.copyWith(
          color: EaselAppTheme.kLightGrey,
        ),),
        Text("40MB limit", style: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: EaselAppTheme.kLightGrey,
        ),),
      ],
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({
    Key? key,
    required this.onClose
  }) : super(key: key);

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);

    return Stack(
      children: [
        Positioned(
          right: 0,
          child: SizedBox(
            width: screenSize.width(),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  height: screenSize.height(percent: 85),
                  // width: screenSize.width(),
                  decoration: BoxDecoration(color: EaselAppTheme.kWhite.withOpacity(0.2)),
                ),
              ),
            ),
          ),
        ),

        Container(
          width: double.infinity,
          height: screenSize.width(percent: 85),
          margin: const EdgeInsets.only(left: 20,),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          decoration: BoxDecoration(
            color: const Color(0xFFFC4403).withOpacity(0.75),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14))
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton( onPressed: onClose, icon: const Icon(Icons.clear, color: Colors.white, size: 30,)),
                  const HorizontalSpace(20),
                 const  Expanded(
                    child: Text('“image_name” could not be uploaded', style: TextStyle(color: Colors.white,
                    fontSize: 18, fontWeight: FontWeight.w500
                    ),),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("• 40MB Limit", style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.white, fontSize: 16
                    ),),
                    Text("• SVG file format", style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.white, fontSize: 16
                    ),),
                    Text("• One file per upload", style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.white, fontSize: 16
                    ),),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
