import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/denom.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:share_plus/share_plus.dart';
import 'package:media_info/media_info.dart';

class EaselProvider extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  EaselProvider(this.localDataSource, this.remoteDataSource);

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
  Denom _selectedDenom = Denom(name: kUSDText, symbol: kUsdSymbol);

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

  String currentUsername = '';

  initStore() {
    _file = null;
    _nftFormat = NftFormat.supportedFormats[0];
    _fileName = "";
    _fileSize = "0";
    _fileHeight = 0;
    _fileWidth = 0;
    _fileDuration = 0;
    _recipeId = "";
    _selectedDenom = Denom(name: kUSDText, symbol: kUsdSymbol);

    artistNameController.clear();
    artNameController.clear();
    descriptionController.clear();
    noOfEditionController.clear();
    priceController.clear();
    royaltyController.clear();
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
      print('kErrFileMetaParse $e');
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

    ScaffoldHelper(navigatorKey.currentState!.overlay!.context).show(message: response.error);
    return false;
  }

  /// sends a createRecipe Tx message to the wallet
  /// return true or false depending on the response from the wallet app
  Future<bool> createRecipe() async {
    if (!shouldMintUSDOrNot()) {
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

    final loading = Loading().showLoading(message: "Uploading ${_nftFormat.format}...");
    final uploadResponse = await remoteDataSource.uploadFile(_file!);
    loading.dismiss();
    if (uploadResponse.status == Status.error) {
      ScaffoldHelper(navigatorKey.currentState!.overlay!.context)
          .show(message: uploadResponse.errorMessage ?? kErrUpload);
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
                LongParam(key: "Quantity", weightRanges: [
                  IntWeightRange(
                      lower: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim())),
                      upper: Int64(int.parse(noOfEditionController.text.replaceAll(",", "").trim())),
                      weight: Int64(1))
                ]),
                LongParam(key: "Width", weightRanges: [
                  IntWeightRange(lower: Int64(_fileWidth), upper: Int64(_fileWidth), weight: Int64(1))
                ]),
                LongParam(key: "Height", weightRanges: [
                  IntWeightRange(lower: Int64(_fileHeight), upper: Int64(_fileHeight), weight: Int64(1))
                ]),
                LongParam(key: "Duration", weightRanges: [
                  IntWeightRange(lower: Int64(_fileDuration), upper: Int64(_fileDuration), weight: Int64(1))
                ]),
              ],
              strings: [
                StringParam(key: "Name", value: artNameController.text.trim()),
                StringParam(key: "App_Type", value: "Easel"),
                StringParam(key: "Description", value: descriptionController.text.trim()),
                StringParam(key: "NFT_Format", value: _nftFormat.format),
                StringParam(key: "NFT_URL", value: "$ipfsDomain/${uploadResponse.data?.value?.cid ?? ""}"),
                StringParam(key: "Creator", value: artistNameController.text.trim()),
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
      ScaffoldHelper(navigatorKey.currentState!.overlay!.context).show(message: kRecipeCreated);
      log("${response.data}");
      return true;
    } else {
      ScaffoldHelper(navigatorKey.currentState!.overlay!.context).show(message: "$kErrRecipe ${response.error}");
      return false;
    }
  }

  bool isDifferentUserName(String savedUserName) => (currentUsername.isNotEmpty && savedUserName != currentUsername);

  Future<void> shareNFT() async {
    String url = FileUtils.generateEaselLink(
      cookbookId: _cookbookId ?? '',
      recipeId: _recipeId,
    );
    Share.share("My Easel NFT\n\n$url", subject: 'My Easel NFT');
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
    }

    return sdkResponse;
  }

  /// false || true (Stripe account doesn't exists and selected Denom is not USD) return true
  /// true  || false (Stripe account exists and selected denom is not USD ) returns true
  /// false || false (Stripe account doesnt exists and selected denom is USD) return false
  /// false || true (Stripe account doesnt exists and selected denom is not  USD) return true

  bool shouldMintUSDOrNot() {
    if (stripeAccountExists || _selectedDenom.symbol != kUsdSymbol) {
      return true;
    }

    ScaffoldHelper(navigatorKey.currentState!.overlay!.context).show(message: kStripeAccountDoesntExists);

    return false;
  }
}
