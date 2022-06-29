import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class CreatorHubViewModel extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  CreatorHubViewModel(this.localDataSource, this.remoteDataSource);

  List<NFT> nftList = [];

  bool _publishCollapse = true;

  bool get publishCollapse => _publishCollapse;

  set publishCollapse(bool value) {
    _publishCollapse = value;
    notifyListeners();
  }

  bool _draftCollapse = true;

  bool get draftCollapse => _draftCollapse;

  set draftCollapse(bool value) {
    _draftCollapse = value;
    notifyListeners();
  }

  Future<void> getDraftsList() async {
    final loading = Loading().showLoading(message: "loading ...");

    nftList = await localDataSource.getNfts();

    loading.dismiss();

    notifyListeners();
  }

  late NFT nft;

  Future<void> saveNft({required EaselProvider provider, required PageController controller}) async {
    final loading = Loading().showLoading(message: "uploading".tr());
    provider.initializeTextEditingControllerWithEmptyValues();
    final uploadResponse = await remoteDataSource.uploadFile(provider.file!);
    if (uploadResponse.status == Status.error) {
      loading.dismiss();

      navigatorKey.currentState!.overlay!.context.show(message: uploadResponse.errorMessage ?? kErrUpload);

      return;
    }
    var uploadThumbnailResponse;
    if (provider.nftFormat.format == kAudioText || provider.nftFormat.format == kVideoText) {
      uploadThumbnailResponse = await remoteDataSource.uploadFile(provider.nftFormat.format == kAudioText ? provider.audioThumbnail! : provider.videoThumbnail!);

      if (uploadThumbnailResponse.status == Status.error) {
        loading.dismiss();

        navigatorKey.currentState!.overlay!.context.show(message: uploadThumbnailResponse.errorMessage ?? kErrUpload);
        return;
      }
    }

    nft = NFT(
      id: null,
      type: NftType.TYPE_ITEM.name,
      ibcCoins: IBCCoins.upylon.name,
      assetType: provider.nftFormat.format,
      cookbookID: provider.cookbookId ?? "",
      width: provider.fileWidth.toString(),
      height: provider.fileHeight.toString(),
      duration: provider.fileDuration.toString(),
      description: provider.descriptionController.text,
      recipeID: provider.recipeId,
      thumbnailUrl: (provider.nftFormat.format == kAudioText || provider.nftFormat.format == kVideoText) ? "$ipfsDomain/${uploadThumbnailResponse.data?.value?.cid}" : "",
      name: provider.artistNameController.text,
      url: "$ipfsDomain/${uploadResponse.data?.value?.cid}",
      price: provider.priceController.text,
      fileName: provider.fileName,
      cid: "${uploadResponse.data?.value?.cid}"
    );

    bool success = await localDataSource.saveNft(nft);
    if (!success) {
      navigatorKey.currentState!.overlay!.context.show(message: "save_error".tr());
      return;
    }
    controller.nextPage(duration: const Duration(milliseconds: 10), curve: Curves.easeIn);
    loading.dismiss();

    Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
  }

  Future<void> deleteDraft(int? id) async {
    bool success = await localDataSource.deleteNft(id!);

    if (!success) {
      navigatorKey.currentState!.overlay!.context.show(message: "delete_error".tr());
      return;
    }
    getDraftsList();
  }
}
