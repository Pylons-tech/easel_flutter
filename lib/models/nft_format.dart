import 'dart:core';

class NftFormat {
  final String format;
  final List<String> extensions;

  NftFormat({required this.format, required this.extensions});
  
  static List<NftFormat> get supportedFormats => [
    NftFormat(format: 'image', extensions: ['jpg', 'png', 'svg', 'heif']),
    NftFormat(format: 'video', extensions: ['mp4']),
    NftFormat(format: '3d', extensions: ['gltf', 'glb']),
    NftFormat(format: 'audio', extensions: ['mp3', 'flac', 'wav']),
  ];

}