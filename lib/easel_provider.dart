import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

import '../utils/enums.dart';

import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/denom.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/services/third_party_services/audio_player_helper.dart';
import 'package:easel_flutter/services/third_party_services/video_player_helper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/file_utils_helper.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:share_plus/share_plus.dart';
import 'package:media_info/media_info.dart';
import 'package:video_player/video_player.dart';

class EaselProvider extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final VideoPlayerHelper videoPlayerHelper;
  final AudioPlayerHelper audioPlayerHelper;
  final FileUtilsHelper fileUtilsHelper;

  EaselProvider({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.videoPlayerHelper,
    required this.audioPlayerHelper,
    required this.fileUtilsHelper,
  });

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
  bool isFreeDrop = false;

  Denom _selectedDenom = Denom.availableDenoms.first;
  List<Denom> supportedDenomList = [];

  late NFT _publishedNFTClicked;

  NFT get publishedNFTClicked => _publishedNFTClicked;

  void setPublishedNFTClicked(NFT nft) {
    _publishedNFTClicked = nft;
    notifyListeners();
  }

  String _publishedNFTDuration = "";

  String get publishedNFTDuration => _publishedNFTDuration;

  void setPublishedNFTDuration(String duration) {
    _publishedNFTDuration = duration;
    notifyListeners();
  }

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

  String get recipeId => _recipeId;

  String? get cookbookId => _cookbookId;

  TextEditingController artistNameController = TextEditingController();
  TextEditingController artNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController noOfEditionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController royaltyController = TextEditingController();
  File? _audioThumbnail;

  File? get audioThumbnail => _audioThumbnail;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  set setIsInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

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

  late ValueNotifier<ProgressBarState> audioProgressNotifier;
  late ValueNotifier<ButtonState> buttonNotifier;

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

  void initializeTextEditingControllerWithEmptyValues() {
    artistNameController.text = '';
    artNameController.text = '';
    descriptionController.text = '';
    noOfEditionController.text = '';
    priceController.text = '';
    royaltyController.text = '';
    notifyListeners();
  }

  void setTextFieldValuesDescription({String? artName, String? description}) {
    artNameController.text = artName ?? "";
    descriptionController.text = description ?? "";
    notifyListeners();
  }

  void setTextFieldValuesPrice({String? royalties, String? price, String? edition, String? denom}) {
    royaltyController.text = royalties ?? "";
    priceController.text = price ?? "";
    noOfEditionController.text = edition ?? "";
    _selectedDenom = denom != "" ? Denom.availableDenoms.firstWhere((element) => element.name == denom) : Denom.availableDenoms.first;
    notifyListeners();
  }

  void updateIsFreeDropStatus(bool val) {
    isFreeDrop = val;
    notifyListeners();
  }

  void stopVideoIfPlaying() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    }
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
  void initializeVideoPlayerWithFile() async {
    videoPlayerHelper.initializeVideoPlayerWithFile(file: _file!);
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

  void initializeVideoPlayerWithUrl({required String publishedNftUrl}) async {
    videoPlayerHelper.initializeVideoPlayerWithUrl(videoUrl: publishedNftUrl);
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

  void setAudioThumbnail(File? file) {
    _audioThumbnail = file;
    notifyListeners();
  }

  bool isUrlLoaded = false;

  late StreamSubscription playerStateSubscription;

  late StreamSubscription positionStreamSubscription;

  late StreamSubscription bufferPositionSubscription;

  late StreamSubscription durationStreamSubscription;

  Future initializeAudioPlayer({required publishedNFTUrl}) async {
    audioProgressNotifier = ValueNotifier<ProgressBarState>(
      ProgressBarState(
        current: Duration.zero,
        buffered: Duration.zero,
        total: Duration.zero,
      ),
    );
    buttonNotifier = ValueNotifier<ButtonState>(ButtonState.loading);

    isUrlLoaded = await audioPlayerHelper.setUrl(url: publishedNFTUrl);

    if (isUrlLoaded) {
      playerStateSubscription = audioPlayerHelper.playerStateStream().listen((playerState) {
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;

        switch (processingState) {
          case ProcessingState.loading:
          case ProcessingState.buffering:
            buttonNotifier.value = ButtonState.loading;
            break;

          case ProcessingState.ready:
            if (!isPlaying) {
              buttonNotifier.value = ButtonState.paused;
              break;
            }
            buttonNotifier.value = ButtonState.playing;
            break;

          default:
            audioPlayerHelper.seekAudio(position: Duration.zero);
            audioPlayerHelper.pauseAudio();
        }
      });
    }

    positionStreamSubscription = audioPlayerHelper.positionStream().listen((position) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    bufferPositionSubscription = audioPlayerHelper.bufferedPositionStream().listen((bufferedPosition) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    durationStreamSubscription = audioPlayerHelper.durationStream().listen((totalDuration) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void playAudio() {
    audioPlayerHelper.playAudio();
  }

  void pauseAudio() {
    audioPlayerHelper.pauseAudio();
  }

  void seekAudio(Duration position) {
    audioPlayerHelper.seekAudio(position: position);
  }

  void disposeAudioController() {
    if (isUrlLoaded) {
      playerStateSubscription.cancel();
      bufferPositionSubscription.cancel();
      durationStreamSubscription.cancel();
      positionStreamSubscription.cancel();
    }
    audioPlayerHelper.destroyAudioPlayer();
  }

  void initializePlayers({required NFT publishedNFT}) {
    switch (publishedNFT.assetType.toAssetTypeEnum()) {
      case AssetType.Audio:
        initializeAudioPlayer(publishedNFTUrl: publishedNFT.url);
        break;
      case AssetType.Image:
        break;
      case AssetType.Video:
        initializeVideoPlayerWithUrl(publishedNftUrl: publishedNFT.url);
        break;

      default:
        break;
    }
  }

  Future<void> setFile(BuildContext context, PlatformFile selectedFile) async {
    _file = File(selectedFile.path!);
    _fileName = selectedFile.name;
    _fileSize = fileUtilsHelper.getFileSizeString(fileLength: _file!.lengthSync());
    _fileExtension = fileUtilsHelper.getExtension(_fileName);
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
    } on PlatformException {
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

  void saveArtistName(name) {
    localDataSource.saveArtistName(name);
  }

  void toCheckSavedArtistName() {
    String savedArtistName = localDataSource.getArtistName();

    if (savedArtistName.isNotEmpty) {
      artistNameController.text = savedArtistName;
      return;
    }
    artistNameController.text = currentUsername;
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
        notifyListeners();
      } else {
        return false;
      }
    }

    _recipeId = localDataSource.autoGenerateEaselId();

    if (_file!.existsSync()) {
      ApiResponse audioThumbnailUploadResponse = ApiResponse.error(errorMessage: "");
      if (audioThumbnail != null) {
        final loading = Loading().showLoading(message: kUploadingThumbnailMessage);

        audioThumbnailUploadResponse = await remoteDataSource.uploadFile(audioThumbnail!);

        loading.dismiss();
      }
      audioPlayerHelper.pauseAudio();

      ApiResponse thumbnailUploadResponse = ApiResponse.error(errorMessage: "");
      if (videoThumbnail != null) {
        final loading = Loading().showLoading(message: kUploadingThumbnailMessage);
        thumbnailUploadResponse = await remoteDataSource.uploadFile(videoThumbnail!);
        setVideoThumbnail(null);
        loading.dismiss();
      }

      final loading = Loading().showLoading(message: "$kUploadingMessage ${_nftFormat.format}...");
      final fileUploadResponse = await remoteDataSource.uploadFile(_file!);
      setAudioThumbnail(null);
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
                        lower: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim())),
                        upper: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim())),
                        weight: Int64(1))
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
                  StringParam(
                      key: kThumbnailUrl,
                      value: videoThumbnail != null
                          ? "$ipfsDomain/${thumbnailUploadResponse.data?.value?.cid ?? ""}"
                          : audioThumbnail != null
                              ? "$ipfsDomain/${audioThumbnailUploadResponse.data?.value?.cid ?? ""}"
                              : ""),
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
      setVideoThumbnail(null);

      if (response.success) {
        navigatorKey.currentState!.overlay!.context.show(message: kRecipeCreated);
        log("${response.data}");
        return true;
      } else {
        navigatorKey.currentState!.overlay!.context.show(message: "$kErrRecipe ${response.error}");
        return false;
      }
    } else {
      navigatorKey.currentState!.overlay!.context.show(message: kErrPickFileFetch);
      return false;
    }
  }

  bool isDifferentUserName(String savedUserName) => (currentUsername.isNotEmpty && savedUserName != currentUsername);

  Future<void> shareNFT(Size size) async {
    String url = fileUtilsHelper.generateEaselLink(
      cookbookId: _cookbookId ?? '',
      recipeId: _recipeId,
    );
    Share.share("$kMyEaselNFT\n\n$url", subject: kMyEaselNFT, sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
  }

  void onVideoThumbnailPicked() async {
    final result = await fileUtilsHelper.pickFile(NftFormat.supportedFormats[0]);

    if (result == null) return;
    final loading = Loading().showLoading(message: kCompressingMessage);
    final file = await fileUtilsHelper.compressAndGetFile(File(result.path!));
    setVideoThumbnail(file);
    loading.dismiss();
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

    await Future.delayed(const Duration(seconds: 1));

    PylonsWallet.instance.showStripe();

    return stripeTryAgainCompleter.future;
  }

  Future initializeAudioPlayerForFile() async {
    audioProgressNotifier = ValueNotifier<ProgressBarState>(
      ProgressBarState(
        current: Duration.zero,
        buffered: Duration.zero,
        total: Duration.zero,
      ),
    );
    buttonNotifier = ValueNotifier<ButtonState>(ButtonState.loading);

    setIsInitialized = await audioPlayerHelper.setFile(file: _file!.path);

    if (isInitialized) {
      audioPlayerHelper.playerStateStream().listen((event) {}).onData((playerState) async {
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;

        switch (processingState) {
          case ProcessingState.idle:
            await audioPlayerHelper.setFile(file: _file!.path);
            break;
          case ProcessingState.loading:
          case ProcessingState.buffering:
            buttonNotifier.value = ButtonState.loading;
            break;

          case ProcessingState.ready:
            if (!isPlaying) {
              buttonNotifier.value = ButtonState.paused;
              break;
            }
            buttonNotifier.value = ButtonState.playing;
            break;

          default:
            audioPlayerHelper.seekAudio(position: Duration.zero);
            audioPlayerHelper.pauseAudio();
        }
      });
    }
    audioPlayerHelper.positionStream().listen((event) {}).onData((position) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    audioPlayerHelper.bufferedPositionStream().listen((event) {}).onData((bufferedPosition) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
    audioPlayerHelper.durationStream().listen((event) {}).onData((totalDuration) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void initilizeTextEditingControllerWithEmptyValues() {
    artistNameController.text = '';
    artNameController.text = '';
    descriptionController.text = '';
    noOfEditionController.text = '';
    priceController.text = '';
    royaltyController.text = '';
    notifyListeners();
  }

  Future<bool> saveNftLocally(UploadStep step) async {
    ApiResponse thumbnailUploadResponse = ApiResponse.error(errorMessage: "");
    ApiResponse audioThumbnailUploadResponse = ApiResponse.error(errorMessage: "");
    bool success = false;
    if (!_file!.existsSync()) {
      navigatorKey.currentState!.overlay!.context.show(message: kErrPickFileFetch);
      return false;
    } else {
      initilizeTextEditingControllerWithEmptyValues();
      if (audioThumbnail != null) {
        final loading = Loading().showLoading(message: kUploadingThumbnailMessage);
        audioThumbnailUploadResponse = await remoteDataSource.uploadFile(audioThumbnail!);
        loading.dismiss();
      }
      audioPlayerHelper.pauseAudio();

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

      if (fileUploadResponse.status == Status.error) {
        navigatorKey.currentState!.overlay!.context.show(message: fileUploadResponse.errorMessage ?? kErrUpload);
        return false;
      }
      NFT nft = NFT(
        id: null,
        type: NftType.TYPE_ITEM.name,
        ibcCoins: IBCCoins.upylon.name,
        assetType: nftFormat.format,
        cookbookID: cookbookId ?? "",
        width: fileWidth.toString(),
        denom: "",
        tradePercentage: "",
        height: fileHeight.toString(),
        duration: fileDuration.toString(),
        description: descriptionController.text,
        recipeID: recipeId,
        step: step.name,
        thumbnailUrl: videoThumbnail != null
            ? "$ipfsDomain/${thumbnailUploadResponse.data?.value?.cid ?? ""}"
            : audioThumbnail != null
                ? "$ipfsDomain/${audioThumbnailUploadResponse.data?.value?.cid ?? ""}"
                : "",
        name: artistNameController.text,
        url: "$ipfsDomain/${fileUploadResponse.data?.value?.cid}",
        price: priceController.text,
      );

      success = await localDataSource.saveNft(nft);
      if (!success) {
        navigatorKey.currentState!.overlay!.context.show(message: "save_error".tr());
        return false;
      }
      setAudioThumbnail(null);

      setVideoThumbnail(null);
    }

    return success;
  }

  Future<bool> updateNftFromDescription(int? id) async {
    bool success = await localDataSource.updateNftFromDescription(id!, artNameController.text, descriptionController.text, artistNameController.text, UploadStep.descriptionAdded.name);
    if (!success) {
      navigatorKey.currentState!.overlay!.context.show(message: "save_error".tr());
      return false;
    }
    return true;
  }

  Future<bool> updateNftFromPrice(int? id) async {
    bool success = await localDataSource.updateNftFromPrice(id!, royaltyController.text, priceController.text, noOfEditionController.text, UploadStep.priceAdded.name, selectedDenom.name);
    if (!success) {
      navigatorKey.currentState!.overlay!.context.show(message: "save_error".tr());
      return false;
    }
    return true;
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
