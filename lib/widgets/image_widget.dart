import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  const ImageWidget({
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
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
