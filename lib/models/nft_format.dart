import 'dart:core';

import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/cupertino.dart';

class NftFormat {
  final String format;
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
            format: kImageText,
            extensions: ['jpg', 'png', 'svg', 'heif', 'jpeg'],
            badge: kSvgNftFormatImage,
            color: EaselAppTheme.kLightRed),
        NftFormat(
            format: kVideoText,
            extensions: ['mp4', 'mov', 'm4v', 'avi'],
            badge: kSvgNftFormatVideo,
            color: EaselAppTheme.kDarkGreen),
        NftFormat(
          format: k3dText,
          extensions: ['gltf', 'glb'],
          badge: kSvgNftFormat3d,
          color: EaselAppTheme.kYellow,
        ),
        NftFormat(
            format: kAudioText,
            extensions: ['wav', 'aiff', 'alac', 'flac', 'mp3', 'aac', 'wma', 'ogg'],
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
