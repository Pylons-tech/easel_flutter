import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/denom.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/services/third_party_services/video_player_helper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:share_plus/share_plus.dart';
import 'package:media_info/media_info.dart';
import 'package:video_player/video_player.dart';

class EaselProvider extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final VideoPlayerHelper videoPlayerHelper;

  EaselProvider(this.localDataSource, this.remoteDataSource, this.videoPlayerHelper);

  File? _file;
  NftFormat _nftFormat = NftFormat.supportedFormats[0];
  String _fileName = "";
  String _fileExtension = "";
  String _fileSize = "0";
  int _fileHeight = 0;
  int _fileWidth = 0;
  int _fileDuration = 0;
  String? _cookbookId;
  String _recipeId = "";
  var stripeAccountExists = false;
  Denom _selectedDenom = Denom.availableDenoms.first;
  List<Denom> supportedDenomList = [];

  File? _videoThumbnail;

  File? get videoThumbnail => _videoThumbnail;

  void setVideoThumbnail(File? file) {
    _videoThumbnail = file;
    notifyListeners();
  }

  File? get file => _file;

  NftFormat get nftFormat => _nftFormat;

  String get fileName => _fileName;

  String get fileExtension => _fileExtension;

  String get fileSize => _fileSize;

  int get fileHeight => _fileHeight;

  int get fileDuration => _fileDuration;

  int get fileWidth => _fileWidth;

  Denom get selectedDenom => _selectedDenom;

  final artistNameController = TextEditingController();
  final artNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final noOfEditionController = TextEditingController();
  final priceController = TextEditingController();
  final royaltyController = TextEditingController();
  final List<String> hashtagsList = [];

  String currentUsername = '';

  late VideoPlayerController videoPlayerController;

  bool _isVideoLoading = true;

  bool get isVideoLoading => _isVideoLoading;

  set isVideoLoading(bool value) {
    _isVideoLoading = value;
    notifyListeners();
  }

  String _videoLoadingError = "";

  String get videoLoadingError => _videoLoadingError;

  set videoLoadingError(String value) {
    _videoLoadingError = value;
    notifyListeners();
  }

  initStore() {
    _file = null;
    _nftFormat = NftFormat.supportedFormats[0];
    _fileName = "";
    _fileSize = "0";
    _fileHeight = 0;
    _fileWidth = 0;
    _fileDuration = 0;
    _recipeId = "";
    _selectedDenom = Denom.availableDenoms.first;

    artistNameController.clear();
    artNameController.clear();
    descriptionController.clear();
    noOfEditionController.clear();
    priceController.clear();
    royaltyController.clear();
    hashtagsList.clear();
    notifyListeners();
  }

  Future<void> setFormat(BuildContext context, NftFormat format) async {
    _nftFormat = format;
    notifyListeners();
  }

  Future<void> resolveNftFormat(BuildContext context, String ext) async {
    for (var format in NftFormat.supportedFormats) {
      if (format.extensions.contains(ext)) {
        _nftFormat = format;
        break;
      }
    }
    notifyListeners();
  }

  Future<void> delayLoading() async {
    Future.delayed(const Duration(seconds: 3));
    isVideoLoading = false;
  }

  /// VIDEO PLAYER FUNCTIONS
  Future initializeVideoPlayer() async {
    videoPlayerHelper.initializeVideoPlayer(file: _file!);
    videoPlayerController = videoPlayerHelper.getVideoPlayerController();
    delayLoading();
    notifyListeners();

    videoPlayerController.addListener(() {
      if (videoPlayerController.value.hasError) {
        videoLoadingError = videoPlayerController.value.errorDescription!;
      }
      notifyListeners();
    });
  }

  void playVideo() {
    videoPlayerHelper.playVideo();
  }

  void pauseVideo() {
    videoPlayerHelper.pauseVideo();
  }

  void seekVideo(Duration position) {
    videoPlayerHelper.seekToVideo(position: position);
  }

  void disposeVideoController() {
    videoPlayerController.removeListener(() {});
    videoPlayerHelper.destroyVideoPlayer();
  }

  Future<void> setFile(BuildContext context, PlatformFile selectedFile) async {
    _file = File(selectedFile.path!);
    _fileName = selectedFile.name;
    _fileSize = FileUtils.getFileSizeString(fileLength: _file!.lengthSync());
    _fileExtension = FileUtils.getExtension(_fileName);
    await _getMetadata(_file!);
    notifyListeners();
  }

  /// get media attributes (width/height/duration) of the file
  /// input [file] and sets [_fileHeight], [_fileWidth], and [_fileDuration]
  Future<void> _getMetadata(File file) async {
    final MediaInfo _mediaInfo = MediaInfo();
    final Map<String, dynamic> info;
    try {
      info = await _mediaInfo.getMediaInfo(file.path);
    } on PlatformException catch (e) {
      _fileWidth = 0;
      _fileHeight = 0;
      _fileDuration = 0;
      return;
    }

    if (_nftFormat.format == kImageText || _nftFormat.format == kVideoText) {
      _fileWidth = info['width'];
      _fileHeight = info['height'];
    }

    if (_nftFormat.format == kAudioText || _nftFormat.format == kVideoText) {
      _fileDuration = info['durationMs'];
    }
  }

  void setSelectedDenom(Denom value) {
    _selectedDenom = value;
    notifyListeners();
  }

  /// send createCookBook tx message to the wallet app
  /// return true or false depending on the response from the wallet app
  Future<bool> createCookbook() async {
    _cookbookId = await localDataSource.autoGenerateCookbookId();
    var cookBook1 = Cookbook(
        creator: "",
        iD: _cookbookId,
        name: "Easel Cookbook",
        description: "Cookbook for Easel NFT",
        developer: artistNameController.text,
        version: "v0.0.1",
        supportEmail: "easel@pylons.tech",
        enabled: true);

    var response = await PylonsWallet.instance.txCreateCookbook(cookBook1);
    if (response.success) {
      localDataSource.saveCookBookGeneratorUsername(currentUsername);
      return true;
    }

    navigatorKey.currentState!.overlay!.context.show(message: response.error);
    return false;
  }

  /// sends a createRecipe Tx message to the wallet
  /// return true or false depending on the response from the wallet app
  Future<bool> createRecipe() async {
    if (!await shouldMintUSDOrNot()) {
      return false;
    }

    // get device cookbook id
    _cookbookId = localDataSource.getCookbookId();
    String savedUserName = localDataSource.getCookBookGeneratorUsername();

    if (_cookbookId == null || isDifferentUserName(savedUserName)) {
      // create cookbook
      final isCookBookCreated = await createCookbook();

      if (isCookBookCreated) {
        // get device cookbook id
        _cookbookId = localDataSource.getCookbookId();
      } else {
        return false;
      }
    }

    _recipeId = localDataSource.autoGenerateEaselId();

    ApiResponse thumbnailUploadResponse = ApiResponse.error(errorMessage: "");
    if (videoThumbnail != null) {
      final loading = Loading().showLoading(message: kUploadingThumbnailMessage);
      thumbnailUploadResponse = await remoteDataSource.uploadFile(videoThumbnail!);
      loading.dismiss();
    }

    final loading = Loading().showLoading(message: "$kUploadingMessage ${_nftFormat.format}...");
    final fileUploadResponse = await remoteDataSource.uploadFile(_file!);
    loading.dismiss();
    if (fileUploadResponse.status == Status.error) {
      navigatorKey.currentState!.overlay!.context.show(message: fileUploadResponse.errorMessage ?? kErrUpload);
      return false;
    }

    String residual = DecString.decStringFromDouble(double.parse(royaltyController.text.trim()));

    String price = (double.parse(priceController.text.replaceAll(",", "").trim()) * 1000000).toStringAsFixed(0);
    var recipe = Recipe(
        cookbookID: _cookbookId,
        iD: _recipeId,
        nodeVersion: "v0.1.0",
        name: artNameController.text.trim(),
        description: descriptionController.text.trim(),
        version: "v0.1.0",
        coinInputs: [
          CoinInput(coins: [Coin(amount: price, denom: _selectedDenom.symbol)])
        ],
        itemInputs: [],
        costPerBlock: Coin(denom: kUpylon, amount: "0"),
        entries: EntriesList(coinOutputs: [], itemOutputs: [
          ItemOutput(
              iD: kEaselNFT,
              doubles: [
                DoubleParam(key: kResidual, weightRanges: [
                  DoubleWeightRange(
                    lower: residual,
                    upper: residual,
                    weight: Int64(1),
                  )
                ])
              ],
              longs: [
                LongParam(key: kQuantity, weightRanges: [
                  IntWeightRange(
                      lower: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim())), upper: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim())), weight: Int64(1))
                ]),
                LongParam(key: kWidth, weightRanges: [IntWeightRange(lower: Int64(_fileWidth), upper: Int64(_fileWidth), weight: Int64(1))]),
                LongParam(key: kHeight, weightRanges: [IntWeightRange(lower: Int64(_fileHeight), upper: Int64(_fileHeight), weight: Int64(1))]),
                LongParam(key: kDuration, weightRanges: [IntWeightRange(lower: Int64(_fileDuration), upper: Int64(_fileDuration), weight: Int64(1))]),
              ],
              strings: [
                StringParam(key: kName, value: artNameController.text.trim()),
                StringParam(key: kAppType, value: kEasel),
                StringParam(key: kDescription, value: descriptionController.text.trim()),
                StringParam(key: kHashtags, value: hashtagsList.join('#')),
                StringParam(key: kNFTFormat, value: _nftFormat.format),
                StringParam(key: kNFTURL, value: "$ipfsDomain/${fileUploadResponse.data?.value?.cid ?? ""}"),
                StringParam(key: kThumbnailUrl, value: videoThumbnail != null ? "$ipfsDomain/${thumbnailUploadResponse.data?.value?.cid ?? ""}" : ""),
                StringParam(key: kCreator, value: artistNameController.text.trim()),
              ],
              mutableStrings: [],
              transferFee: [Coin(denom: kPylonSymbol, amount: "1")],
              tradePercentage: DecString.decStringFromDouble(double.parse(royaltyController.text.trim())),
              tradeable: true,
              amountMinted: Int64(0),
              quantity: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim()))),
        ], itemModifyOutputs: []),
        outputs: [
          WeightedOutputs(entryIDs: [kEaselNFT], weight: Int64(1))
        ],
        blockInterval: Int64(0),
        enabled: true,
        extraInfo: kExtraInfo);

    log('RecipeResponse: ${recipe.toProto3Json()}');

    var response = await PylonsWallet.instance.txCreateRecipe(recipe, requestResponse: false);

    log('From App $response');

    if (response.success) {
      navigatorKey.currentState!.overlay!.context.show(message: kRecipeCreated);
      log("${response.data}");
      return true;
    } else {
      navigatorKey.currentState!.overlay!.context.show(message: "$kErrRecipe ${response.error}");
      return false;
    }
  }

  bool isDifferentUserName(String savedUserName) => (currentUsername.isNotEmpty && savedUserName != currentUsername);

  Future<void> shareNFT(Size size) async {
    String url = FileUtils.generateEaselLink(
      cookbookId: _cookbookId ?? '',
      recipeId: _recipeId,
    );
    Share.share("My Easel NFT\n\n$url", subject: 'My Easel NFT', sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
  }

  @override
  void dispose() {
    artistNameController.dispose();
    artNameController.dispose();
    descriptionController.dispose();
    noOfEditionController.dispose();
    royaltyController.dispose();
    super.dispose();
  }

  Future<SDKIPCResponse<Profile>> getProfile() async {
    var sdkResponse = await PylonsWallet.instance.getProfile();

    if (sdkResponse.success) {
      currentUsername = sdkResponse.data.username;
      stripeAccountExists = sdkResponse.data.stripeExists;

      supportedDenomList = Denom.availableDenoms.where((Denom e) => sdkResponse.data.supportedCoins.contains(e.symbol)).toList();

      if (supportedDenomList.isNotEmpty) {
        _selectedDenom = supportedDenomList.first;
      }
    }

    return sdkResponse;
  }

  /// false || true (Stripe account doesn't exists and selected Denom is not USD) return true
  /// true  || false (Stripe account exists and selected denom is not USD ) returns true
  /// false || false (Stripe account doesnt exists and selected denom is USD) return false
  /// false || true (Stripe account doesnt exists and selected denom is not  USD) return true
  Future<bool> shouldMintUSDOrNot() async {
    if (stripeAccountExists || _selectedDenom.symbol != kUsdSymbol) {
      return true;
    }

    Completer<bool> stripeTryAgainCompleter = Completer<bool>();

    ScaffoldMessenger.maybeOf(navigatorKey.currentState!.overlay!.context)?.hideCurrentSnackBar();
    ScaffoldMessenger.maybeOf(navigatorKey.currentState!.overlay!.context)!.showSnackBar(SnackBar(
      content: Text(
        kErrNoStripeAccount,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 14.sp,
        ),
      ),
      duration: const Duration(days: 1),
      action: SnackBarAction(
        onPressed: () async {
          await getProfile();
          stripeTryAgainCompleter.complete(stripeAccountExists);
        },
        label: kTryAgain,
      ),
    ));

    return stripeTryAgainCompleter.future;
  }
}
