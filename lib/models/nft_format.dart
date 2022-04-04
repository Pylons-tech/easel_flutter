import 'dart:core';

import 'package:easel_flutter/utils/constants.dart';

class NftFormat {
  final String format;
  final List<String> extensions;
  final String badge;

  NftFormat({required this.format, required this.extensions, required this.badge});

  String getExtensionsList() {
    var ret = '';
    for (var i = 0; i < extensions.length; i++) {
      if (i == 4) {
        ret += ',\n';
      } else if (ret.isNotEmpty) {
        ret += ', ';
      }
      ret += extensions[i].toUpperCase();
    }
    return ret;
  }

  static List<NftFormat> get supportedFormats => [
        NftFormat(format: kImageText, extensions: ['jpg', 'png', 'svg', 'heif', 'jpeg'], badge: kSvgNftTypeImage),
        NftFormat(format: kVideoText, extensions: ['mp4', 'mov', 'm4v', 'avi'], badge: kSvgNftTypeVideo),
        NftFormat(format: k3dText, extensions: ['gltf', 'glb'], badge: kSvgNftType3d),
        NftFormat(
            format: kAudioText,
            extensions: ['wav', 'aiff', 'alac', 'flac', 'mp3', 'aac', 'wma', 'ogg'],
            badge: kSvgNftTypeAudio),
      ];

  static List<String> getAllSupportedExts() {
    List<String> allExts = [];
    for (var i = 0; i < supportedFormats.length; i++) {
      allExts += supportedFormats[i].extensions;
    }
    return allExts;
  }
}
