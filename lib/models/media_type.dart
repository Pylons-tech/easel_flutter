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
        title: 'Image',
        subTitle: "JPG, PNG or SVG",
        iconName: "assets/icons/file.png"),
    MediaType(
        index: 1,
        title: 'Video',
        subTitle: "MP4",
        iconName: "assets/icons/file.png"),
    MediaType(
        index: 1,
        title: '3D',
        subTitle: "GLTF or GLB",
        iconName: "assets/icons/file.png"),
    MediaType(
        index: 1,
        title: 'Audio',
        subTitle: "MP3, FLAC or WAV",
        iconName: "assets/icons/file.png"),
  ];
}
