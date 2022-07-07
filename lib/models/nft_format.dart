import 'dart:core';

import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/cupertino.dart';

class NftFormat {
  final NFTTypes format;
  final List<String> extensions;
  final String badge;
  final Color color;

  NftFormat({required this.format, required this.extensions, required this.badge, required this.color});

  String getExtensionsList() {
    var ret = '';
    for (var i = 0; i < extensions.length; i++) {
      if (ret.isNotEmpty) {
        ret += ', ';
      }
      ret += extensions[i].toUpperCase();
    }
    return ret;
  }

  static List<NftFormat> get supportedFormats => [
        NftFormat(
            format: NFTTypes.image,
            extensions: ['jpg', 'png', 'svg', 'heif'],
            badge: kSvgNftFormatImage,
            color: EaselAppTheme.kLightRed),
        NftFormat(
            format: NFTTypes.video,
            extensions: ['mp4'],
            badge: kSvgNftFormatVideo,
            color: EaselAppTheme.kDarkGreen),
        NftFormat(
          format: NFTTypes.threeD,
          extensions: ['gltf', 'glb'],
          badge: kSvgNftFormat3d,
          color: EaselAppTheme.kYellow,
        ),
        NftFormat(
            format: NFTTypes.audio,
            extensions: [ 'mp3', 'flac',  'wav'],
            badge: kSvgNftFormatAudio,
            color: EaselAppTheme.kBlue),
      ];

  static List<String> getAllSupportedExts() {
    List<String> allExts = [];
    for (var format in supportedFormats) {
      allExts += format.extensions;
    }
    return allExts;
  }
}



enum NFTTypes {
  image,
  video,
  audio,
  threeD
}

extension NFTTypesDetails on NFTTypes{
  String getTitle(){
    switch(this){

      case NFTTypes.image:
        return kImageText;
      case NFTTypes.video:
        return kVideoText;
      case NFTTypes.audio:
        return kAudioText;
      case NFTTypes.threeD:
        return k3dText;
    }

  }
}
