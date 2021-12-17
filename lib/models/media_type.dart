import 'package:easel_flutter/utils/constants.dart';

class MediaType {
  final int index;
  final String title;
  final String subTitle;
  final String iconName;

  MediaType(
      {required this.index,
      required this.title,
      required this.subTitle,
      required this.iconName});

  static List<MediaType> listTypes = <MediaType>[
    MediaType(
        index: 0,
        title: kImages,
        subTitle: kImageType,
        iconName: kImageIconPath),
    MediaType(
        index: 1,
        title: kVideos,
        subTitle: kVideoType,
        iconName: kVideoIconPath),
    MediaType(index: 1, title: k3Ds, subTitle: k3DType, iconName: k3DIconPath),
    MediaType(
        index: 1,
        title: kAudios,
        subTitle: kAudioType,
        iconName: kAudioIconPath),
  ];
}
