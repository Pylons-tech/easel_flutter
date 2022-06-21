import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/denom.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/services/third_party_services/audio_player_helper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/file_utils.dart';
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

class EaselProvider extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final AudioPlayerHelper audioPlayerHelper;

  EaselProvider(this.localDataSource, this.remoteDataSource, this.audioPlayerHelper);

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

  File? get file => _file;

  NftFormat get nftFormat => _nftFormat;

  String get fileName => _fileName;

  String get fileExtension => _fileExtension;

  String get fileSize => _fileSize;

  int get fileHeight => _fileHeight;

  int get fileDuration => _fileDuration;

  int get fileWidth => _fileWidth;

  Denom get selectedDenom => _selectedDenom;

  File? _audioThumbnail;

  File? get audioThumnail => _audioThumbnail;

  final artistNameController = TextEditingController();
  final artNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final noOfEditionController = TextEditingController();
  final priceController = TextEditingController();
  final royaltyController = TextEditingController();
  final List<String> hashtagsList = [];

  String currentUsername = '';

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

  void setAudioThumbnail(File? file) {
    _audioThumbnail = file;
    notifyListeners();
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
      } else {
        return false;
      }
    }

    _recipeId = localDataSource.autoGenerateEaselId();

    ApiResponse audioThumbnailUploadResponse = ApiResponse.error(errorMessage: "");
    if (audioThumnail != null) {
      final loading = Loading().showLoading(message: kUploadingThumbnailMessage);
      audioThumbnailUploadResponse = await remoteDataSource.uploadFile(audioThumnail!);
      setAudioThumbnail(null);
      loading.dismiss();
    }

    final loading = Loading().showLoading(message: "Uploading ${_nftFormat.format}...");
    final uploadResponse = await remoteDataSource.uploadFile(_file!);
    loading.dismiss();
    if (uploadResponse.status == Status.error) {
      navigatorKey.currentState!.overlay!.context.show(message: uploadResponse.errorMessage ?? kErrUpload);
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
        costPerBlock: Coin(denom: "upylon", amount: "0"),
        entries: EntriesList(coinOutputs: [], itemOutputs: [
          ItemOutput(
              iD: "Easel_NFT",
              doubles: [
                DoubleParam(key: "Residual", weightRanges: [
                  DoubleWeightRange(
                    lower: residual,
                    upper: residual,
                    weight: Int64(1),
                  )
                ])
              ],
              longs: [
                LongParam(key: kQuantityKey, weightRanges: [
                  IntWeightRange(
                      lower: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim())), upper: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim())), weight: Int64(1))
                ]),
                LongParam(key: kWidthKey, weightRanges: [IntWeightRange(lower: Int64(_fileWidth), upper: Int64(_fileWidth), weight: Int64(1))]),
                LongParam(key: kHeightKey, weightRanges: [IntWeightRange(lower: Int64(_fileHeight), upper: Int64(_fileHeight), weight: Int64(1))]),
                LongParam(key: kDurationText, weightRanges: [IntWeightRange(lower: Int64(_fileDuration), upper: Int64(_fileDuration), weight: Int64(1))]),
              ],
              strings: [
                StringParam(key: kNameKey, value: artNameController.text.trim()),
                StringParam(key: kAppTypeKey, value: "Easel"),
                StringParam(key: kDescriptionKey, value: descriptionController.text.trim()),
                StringParam(key: kHashtagKey, value: hashtagsList.join('#')),
                StringParam(key: kNftFormatKey, value: _nftFormat.format),
                StringParam(key: kNftUrlKey, value: "$ipfsDomain/${uploadResponse.data?.value?.cid ?? ""}"),
                StringParam(key: kThumbnailUrl, value: audioThumnail != null ? "$ipfsDomain/${audioThumbnailUploadResponse.data?.value?.cid ?? ""}" : ""),
                StringParam(key: kCreatorKey, value: artistNameController.text.trim()),
                StringParam(key: kSizeKey, value: _fileSize.trim()),
              ],
              mutableStrings: [],
              transferFee: [Coin(denom: kPylonSymbol, amount: "1")],
              tradePercentage: DecString.decStringFromDouble(double.parse(royaltyController.text.trim())),
              tradeable: true,
              amountMinted: Int64(0),
              quantity: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim()))),
        ], itemModifyOutputs: []),
        outputs: [
          WeightedOutputs(entryIDs: ["Easel_NFT"], weight: Int64(1))
        ],
        blockInterval: Int64(0),
        enabled: true,
        extraInfo: "extraInfo");

    log("${recipe.toProto3Json()}");
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

    await Future.delayed(const Duration(seconds: 1));

    PylonsWallet.instance.showStripe();

    return stripeTryAgainCompleter.future;
  }

  Future initializeAudioPlayer() async {
    audioProgressNotifier = ValueNotifier<ProgressBarState>(
      ProgressBarState(
        current: Duration.zero,
        buffered: Duration.zero,
        total: Duration.zero,
      ),
    );
    buttonNotifier = ValueNotifier<ButtonState>(ButtonState.loading);

    final bool isUrlLoaded = await audioPlayerHelper.setFile(file: _file!.path);

    if (isUrlLoaded) {
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
    audioPlayerHelper.destroyAudioPlayer();
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
