import 'dart:ui';

import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart' as clipper;
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart';
import 'package:easel_flutter/screens/custom_widgets/step_labels.dart';
import 'package:easel_flutter/screens/custom_widgets/steps_indicator.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/read_more.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/model_viewer.dart';
import 'package:easel_flutter/widgets/video_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../widgets/video_progress_widget.dart';

TextStyle _rowTitleTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: isTablet ? 11.sp : 13.sp);

class PublishedScreen extends StatefulWidget {
  const PublishedScreen({Key? key}) : super(key: key);

  @override
  State<PublishedScreen> createState() => _PublishedScreenState();
}

class _PublishedScreenState extends State<PublishedScreen> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => const PublishedNewScreen(),
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return const PublishedNewScreen();
  }
}

class PublishedNewScreen extends StatefulWidget {
  const PublishedNewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PublishedNewScreen> createState() => _PublishedNewScreenState();
}

class _PublishedNewScreenState extends State<PublishedNewScreen> {
  var repository = GetIt.I.get<Repository>();
  var easelProvider = GetIt.I.get<EaselProvider>();
  var homeViewModel = GetIt.I.get<HomeViewModel>();

  @override
  initState() {
    easelProvider.nft = repository.getCacheDynamicType(key: "nft");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async {
        homeViewModel.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        return true;
      },
      child: Consumer<EaselProvider>(builder: (_, easelProvider, __) {
        return Scaffold(
          backgroundColor: EaselAppTheme.kBlack,
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 10),
            child: Stack(
              children: [
                SizedBox(width: double.infinity, child: buildPreviewWidget(easelProvider)),
                Image.asset(kPreviewGradient, width: 1.sw, fit: BoxFit.fill),

                Positioned(
                    left: 10.w,
                    top: 60.h,
                    child: IconButton(
                      onPressed: () {
                        homeViewModel.currentPage = ValueNotifier(1);
                        homeViewModel.currentStep = ValueNotifier(1);
                        homeViewModel.previousPage();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: EaselAppTheme.kWhite,
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: OwnerBottomDrawer(nft: easelProvider.nft),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildPreviewWidget(EaselProvider provider) {
    switch (provider.nft.assetType) {
      case kImageText:
        return ImageWidget(filePath: provider.nft.url);
      case kVideoText:
        return VideoWidget(
          filePath: provider.nft.url,
          previewFlag: true,
          isForFile: false,
        );
      case k3dText:
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.78,
            width: 1.sw,
            child: Model3dViewer(
              path: provider.nft.url,
              isFile: false,
            ));
      case kAudioText:
        return AudioWidget(filePath: provider.nft.url, previewFlag: false);
    }
    return const SizedBox.shrink();
  }
}

class OwnerBottomDrawer extends StatefulWidget {
  final NFT nft;

  const OwnerBottomDrawer({Key? key, required this.nft}) : super(key: key);

  @override
  State<OwnerBottomDrawer> createState() => _OwnerBottomDrawerState();
}

class _OwnerBottomDrawerState extends State<OwnerBottomDrawer> {
  bool liked = false;
  String owner = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EaselProvider>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildPublishBottomSheet(
            collapseStatus: viewModel.collapsed,
            onCollapsed: (context) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        size: 32.h,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        viewModel.toChangeCollapse();
                      },
                    ),
                  ),
                  _title(
                    nft: widget.nft,
                    owner: widget.nft.type == NftType.TYPE_RECIPE.name ? "you".tr() : widget.nft.creator,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  viewModel.nft.assetType == kVideoText ? const VideoProgressWidget(darkMode: true, isForFile: false) : const SizedBox(),
                ],
              ),
            ),
            onOpened: (context) => Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ClipPath(
                    clipper: RightTriangleClipper(orientation: clipper.Orientation.orientationSW),
                    child: Container(
                      color: EaselAppTheme.kLightRed,
                      height: 50,
                      width: 50,
                      child: Center(
                          child: IconButton(
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          left: 8,
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        onPressed: () {
                          viewModel.toChangeCollapse();
                        },
                        iconSize: 32,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: ExpandedViewClipper(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black54,
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _title(nft: widget.nft, owner: widget.nft.type == NftType.TYPE_RECIPE.name ? "you".tr() : widget.nft.creator),
                          SizedBox(
                            height: 20.h,
                          ),
                          if (widget.nft.hashtags.isNotEmpty)
                            Wrap(
                                spacing: 10.w,
                                children: List.generate(
                                    viewModel.hashtagsList.length,
                                    (index) => SizedBox(
                                          child: DetectableText(
                                            text: "#${viewModel.hashtagsList[index]}",
                                            detectionRegExp: detectionRegExp()!,
                                            detectedStyle: TextStyle(
                                              fontSize: 12.sp,
                                              color: EaselAppTheme.kHashtagColor,
                                            ),
                                            basicStyle: TextStyle(
                                              fontSize: 20.sp,
                                            ),
                                            onTap: (tappedText) {},
                                          ),
                                        ))),
                          SizedBox(
                            height: 10.h,
                          ),
                          ReadMoreText(
                            widget.nft.description,
                            trimExpandedText: "collapse".tr(),
                            trimCollapsedText: "read_more".tr(),
                            moreStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300, color: EaselAppTheme.kLightPurple),
                            lessStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300, color: EaselAppTheme.kLightPurple),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          viewModel.nft.assetType == kVideoText
                              ? Container(
                                  width: 250.w,
                                  color: EaselAppTheme.kWhite.withOpacity(0.2),
                                  child: const VideoProgressWidget(darkMode: false, isForFile: false),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: 30.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    buildRow(
                                      title: "currency".tr(),
                                      subtitle: widget.nft.isFreeDrop ? kPylonText : (viewModel.supportedDenomList.firstWhere((denom) => denom.symbol == widget.nft.denom).name),
                                    ),
                                    SizedBox(height: 2.h),
                                    buildRow(
                                      title: "price".tr(),
                                      subtitle: widget.nft.isFreeDrop
                                          ? "0"
                                          : widget.nft.denom == kUsdSymbol
                                              ? "\$${widget.nft.price}"
                                              : widget.nft.price,
                                    ),
                                    SizedBox(height: 10.h),
                                    buildRow(
                                      title: "editions".tr(),
                                      subtitle: widget.nft.quantity.toString(),
                                    ),
                                    SizedBox(height: 2.h),
                                    buildRow(
                                      title: "royalty".tr(),
                                      subtitle: "${widget.nft.tradePercentage}%",
                                    ),
                                    SizedBox(height: 10.h),
                                    buildRow(
                                      title: "content_identifier".tr(),
                                      subtitle: widget.nft.cid,
                                    ),
                                    SizedBox(height: 2.h),
                                    buildRow(
                                      title: "asset_uri".tr(),
                                      subtitle: "view".tr(),
                                    ),
                                    SizedBox(height: 50.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ClippedButton(
                                            title: "save".tr(),
                                            bgColor: Colors.white.withOpacity(0.2),
                                            textColor: EaselAppTheme.kWhite,
                                            onPressed: () async {
                                              Navigator.of(context).popUntil(ModalRoute.withName(RouteUtil.kRouteCreatorHub));
                                            },
                                            cuttingHeight: 15.h,
                                            clipperType: ClipperType.topLeftBottomRight,
                                            isShadow: false,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30.w,
                                        ),
                                        Expanded(
                                          child: ClippedButton(
                                            title: "publish".tr(),
                                            bgColor: EaselAppTheme.kLightRed,
                                            textColor: EaselAppTheme.kWhite,
                                            onPressed: () async {
                                              bool isRecipeCreated = await viewModel.verifyPylonsAndMint(nft: viewModel.nft);
                                              if (!isRecipeCreated) {
                                                return;
                                              }
                                              viewModel.disposeAudioController();
                                              Navigator.of(context).pushNamedAndRemoveUntil(RouteUtil.kRouteCreatorHub, (route) => false);
                                            },
                                            cuttingHeight: 15.h,
                                            clipperType: ClipperType.topLeftBottomRight,
                                            isShadow: false,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _title({required NFT nft, required String owner}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                nft.name,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "created_by".tr(),
                style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
              TextSpan(text: owner, style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 18.sp, fontWeight: FontWeight.w500)),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SvgPicture.asset(
                    kOwnerVerifiedIcon,
                    height: 15.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onViewOnIPFSPressed({required EaselProvider provider}) async {
    await provider.repository.launchMyUrl(url: provider.nft.url);
  }

  Widget buildRow({required String title, required String subtitle}) {
    final viewModel = context.watch<EaselProvider>();
    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          style: _rowTitleTextStyle,
        )),
        Expanded(
            child: subtitle.length > 14
                ? Row(
                    children: [
                      Text(
                        subtitle.substring(0, 8),
                        style: _rowTitleTextStyle,
                      ),
                      const Text("...",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      Text(
                        subtitle.substring(subtitle.length - 5, subtitle.length),
                        style: _rowTitleTextStyle,
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      clipboardWidget(subtitle)
                    ],
                  )
                : Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (title == "asset_uri".tr()) {
                            onViewOnIPFSPressed(
                              provider: viewModel,
                            );
                          }
                        },
                        child: Text(
                          subtitle,
                          style: title == "asset_uri".tr() ? _rowTitleTextStyle.copyWith(color: EaselAppTheme.kLightPurple) : _rowTitleTextStyle,
                        ),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      if (title == "content_identifier".tr()) clipboardWidget(subtitle)
                    ],
                  ))
      ],
    );
  }

  Widget clipboardWidget(subtitle) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: subtitle));
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("copied_to_clipboard".tr())),
        );
      },
      child: Icon(
        Icons.copy_outlined,
        color: EaselAppTheme.kWhite,
        size: 15.h,
      ),
    );
  }
}

class ExpandedViewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 50);
    path.lineTo(size.width - 50, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BuildPublishBottomSheet extends StatelessWidget {
  final WidgetBuilder onCollapsed;
  final WidgetBuilder onOpened;
  final bool collapseStatus;

  const BuildPublishBottomSheet({Key? key, required this.onCollapsed, required this.onOpened, required this.collapseStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (collapseStatus) {
      case true:
        return onCollapsed(context);
      case false:
        return onOpened(context);
    }
    ;

    return const SizedBox();
  }
}
