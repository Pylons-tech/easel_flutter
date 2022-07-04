import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends ChangeNotifier {
  final Repository repository;

  HomeViewModel(this.repository);

  late ValueNotifier<int> currentPage;

  late ValueNotifier<int> currentStep;
  late PageController pageController;

  NFT? nft;
  String? from;
  final List pageTitles = ["select_nft_file".tr(), "nft_detail_text".tr(), "nft_pricing".tr(), ''];

  init( {required VoidCallback setTextField}) {
    from = repository.getCacheString(key: "from");
    repository.deleteCacheString(key: "from");

    if (from == kDraft) {
      nft = repository.getCacheDynamicType(key: "nft");

      Future.delayed(const Duration(milliseconds: 1), () {

        setTextField.call();
           });

      if (nft!.step == UploadStep.assetUploaded.name) {
        currentPage = ValueNotifier(1);
        currentStep = ValueNotifier(1);
        pageController = PageController(keepPage: true, initialPage: 1);
        return;
      } else if (nft!.step == UploadStep.descriptionAdded.name) {
        currentPage = ValueNotifier(1);
        currentStep = ValueNotifier(1);
        pageController = PageController(keepPage: true, initialPage: 2);
        return;
      } else if (nft!.step == UploadStep.priceAdded.name) {
        currentPage = ValueNotifier(2);
        currentStep = ValueNotifier(2);
        pageController = PageController(keepPage: true, initialPage: 3);
        return;
      } else {
        currentPage = ValueNotifier(0);
        currentStep = ValueNotifier(0);
        pageController = PageController(keepPage: true, initialPage: 0);
      }
    } else {
      currentPage = ValueNotifier(0);
      currentStep = ValueNotifier(0);
      pageController = PageController(keepPage: true, initialPage: 0);
    }
  }

  disposeControllers() {
    pageController.dispose();
  }
}
