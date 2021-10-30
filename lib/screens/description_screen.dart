import 'package:easel_flutter/widgets/pylons_round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptionScreen extends StatelessWidget {
  final PageController controller;
  DescriptionScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              EaselTextField(title: "Your name as the artist",),
              SizedBox(height: 20,),
              EaselTextField(title: "Give your NFT a name",),
              SizedBox(height: 20,),
              EaselTextField(title: "Describe your NFT", noOfLines: 4,),
              SizedBox(height: 20,),
              EaselTextField(title: "Number of Edition (Max: 100)", keyboardType: TextInputType.number,),
              SizedBox(height: 20,),
              EaselTextField(title: "Royalties", hint: "10%", keyboardType: TextInputType.numberWithOptions(decimal: true),),
              SizedBox(height: 20,),
              PylonsRoundButton(onPressed: (){
                print(controller.page!);
                final yy = controller.page!;
                double xx = yy < 3.0 ? (yy + 1) : 3;
                print(xx);
                controller.jumpToPage(xx.toInt());
              }),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}

class EaselTextField extends StatelessWidget {
  const EaselTextField({
    Key? key,
    required this.title,
    this.hint = "",
    this.controller, this.validator,
    this.noOfLines = 1,
    this.keyboardType = TextInputType.text
  }) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int noOfLines;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      minLines: noOfLines,
      maxLines: noOfLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xff1212C4).withOpacity(0.2))
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xff1212C4).withOpacity(0.2))
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xff1212C4).withOpacity(0.2))
        ),
        labelText: title,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: hint,
        labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: 16
        ),
        floatingLabelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 20
        )
      ),
    );
  }
}
