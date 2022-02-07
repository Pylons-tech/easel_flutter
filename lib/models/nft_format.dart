import 'dart:core';

import 'package:easel_flutter/utils/constants.dart';

class NftFormat {
  final String format;
  final List<String> extensions;

  NftFormat({required this.format, required this.extensions});
  
  static List<NftFormat> get supportedFormats => [
    NftFormat(format: kImageText, extensions: ['jpg', 'png', 'svg', 'heif']),
    NftFormat(format: kVideoText, extensions: ['mp4']),
    NftFormat(format: k3dText, extensions: ['gltf', 'glb']),
    NftFormat(format: kAudioText, extensions: ['mp3', 'flac', 'wav']),
  ];

}