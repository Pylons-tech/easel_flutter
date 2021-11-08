import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:easel_flutter/datasources/local_datasource.dart';
import 'package:easel_flutter/datasources/remote_datasource.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/storage_response_model.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:pylons_flutter/pylons_flutter.dart';
import 'package:share/share.dart';

class EaselProvider extends ChangeNotifier {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;


  EaselProvider(this.localDataSource, this.remoteDataSource);

  File? _file;
  String _fileName = "";
  String _fileExtension = "";
  String _fileSize = "0";
  int _fileHeight = 0;
  int _fileWidth = 0;
  String? _cookbookId;
  String _recipeId = "";

  File? get file => _file;
  String get fileName => _fileName;
  String get fileExtension => _fileExtension;
  String get fileSize => _fileSize;
  int get fileHeight => _fileHeight;
  int get fileWidth => _fileWidth;


  final artistNameController = TextEditingController();
  final artNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final noOfEditionController = TextEditingController();
  final priceController = TextEditingController();
  final royaltyController = TextEditingController();

  initStore(){
    _file = null;
   _fileName = "";
   _fileSize = "0";
   _fileHeight = 0;
    _fileWidth = 0;
   _recipeId = "";

   artistNameController.clear();
   artNameController.clear();
   descriptionController.clear();
   noOfEditionController.clear();
   priceController.clear();
   royaltyController.clear();
   // formKey.currentState?.reset();
   notifyListeners();
  }

  Future<void> setFile(BuildContext context, PlatformFile selectedFile)async{

    // if(FileUtils.isSvgFile(selectedFile.path)){
    //   selectedFile = await FileUtils.convertSvgToPngFile(context, selectedFile);
    // }

    _file = File(selectedFile.path!);
    _fileName = selectedFile.name;
    _fileSize = FileUtils.getFileSizeInMB(_file!.lengthSync()).toStringAsFixed(2);
    _fileExtension = FileUtils.getExtension(_fileName);
    await _calculateDimension(_file!);
    notifyListeners();

    // /data/user/0/tech.pylons.easel/app_flutter/Easel_11082021_135126507.png
  }


  /// calculates the width and height of a file
  /// input [file] and sets [_fileHeight] and [_fileWidth]
  Future<void> _calculateDimension(File file)async{
    final image = Image.file(file);
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo image, bool _) {
      completer.complete(image.image);
    }));
    ui.Image info = await completer.future;
    _fileWidth = info.width;
    _fileHeight = info.height;
  }


  /// send createCookBook tx message to the wallet app
  /// return true or false depending on the response from the wallet app
  Future<bool> createCookbook()async{

    _cookbookId = await localDataSource.autoGenerateCookbookId();
    var cookBook1 = Cookbook(
        creator: "",
        iD: _cookbookId,
        name: "Easel Cookbook",
        nodeVersion: "v0.1.0",
        description: "Cookbook for Easel NFT",
        developer: artistNameController.text,
        version: "v0.0.1",
        supportEmail: "easel@pylons.tech",
        costPerBlock: Coin(denom: "upylon", amount: "1"), enabled: true);


    var response = await PylonsWallet.instance.txCreateCookbook(cookBook1);
    if(response.success){
      return true;
    }

    ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context).showSnackBar(SnackBar(content: Text(response.error)));
    return false;
  }


  /// sends a createRecipe Tx message to the wallet
  /// return true or false depending on the response from the wallet app
  Future<bool> createRecipe()async{

    _cookbookId = localDataSource.getCookbookId();
    if(_cookbookId == null){

      final isCookBookCreated = await createCookbook();

      if(isCookBookCreated) {
        _cookbookId = localDataSource.getCookbookId();
      }else{
        return false;
      }
    }
    log("$_cookbookId");
    _recipeId = localDataSource.autoGenerateEaselId();
    log(_recipeId);
    log("${double.parse(royaltyController.text.trim())}");

    final uploadResponse = await remoteDataSource.uploadFile(_file!);
    if(uploadResponse.status == Status.error){
      ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context).showSnackBar(SnackBar(content: Text(uploadResponse.errorMessage ?? "Upload error occurred")));
      return false;
    }

    // print((double.parse(royaltyController.text.trim()) * 1000000000000000000.0).toStringAsFixed(0));
    // print(DecString.decStringFromDouble(double.parse(royaltyController.text.trim())));
    String residual = (double.parse(royaltyController.text.trim()) * 1000000000000000000).toStringAsFixed(0);
    var recipe = Recipe(
        cookbookID: _cookbookId,
        iD: _recipeId,
        nodeVersion: "v0.1.0",
        name: artNameController.text.trim(),
        description: descriptionController.text.trim(),
        version: "v0.1.0",
        coinInputs: [
          CoinInput(coins: [Coin(amount: priceController.text.trim(), denom: "upylon")])

        ],
        itemInputs: [],
        entries: EntriesList(coinOutputs: [], itemOutputs: [
          ItemOutput(
            iD: "Easel_NFT",
            doubles: [
              DoubleParam(key: "Residual", weightRanges: [
                DoubleWeightRange(
                    lower: residual,
                    upper: residual,
                    weight: Int64(1),)
              ])
            ],
            longs: [
              LongParam(key: "Quantity", weightRanges: [
                IntWeightRange(lower: Int64(int.parse(noOfEditionController.text.trim())),
                    upper: Int64(int.parse(noOfEditionController.text.trim())),
                    weight: Int64(1))
              ]),
              LongParam(key: "Width", weightRanges: [
                IntWeightRange(lower: Int64(34), upper: Int64(43), weight: Int64(1))
              ]),
              LongParam(key: "Height", weightRanges: [
                IntWeightRange(lower: Int64(34), upper: Int64(43), weight: Int64(1))
              ])
            ],
            strings: [
              StringParam(key: "Name", value: artNameController.text.trim()),
              StringParam(key: "App_Type", value: "Easel"),
              StringParam(key: "Description", value: descriptionController.text.trim()),
              StringParam(key: "NFT_URL", value: "$ipfsDomain/${uploadResponse.data?.value?.cid ?? ""}"),
              StringParam(key: "Currency", value: "upylon"),
              StringParam(key: "Price", value: priceController.text.trim()),
              StringParam(key: "Creator", value: artistNameController.text.trim()),
            ],
            mutableStrings: [],
            transferFee: [
              Coin(denom: "upylon", amount: "10")
            ],
            tradePercentage: DecString.decStringFromDouble(double.parse(royaltyController.text.trim())),
            tradeable: true,
          ),
        ], itemModifyOutputs: []),
        outputs: [
          WeightedOutputs(entryIDs: ["Easel_NFT"], weight: Int64(1))
        ],
        blockInterval: Int64(0),
        enabled: true,
        extraInfo: "extraInfo");

    log("${recipe.toProto3Json()}");
    var response = await PylonsWallet.instance.txCreateRecipe(recipe);

    print('From App $response');

    if (response.success) {
      ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context).showSnackBar(const SnackBar(content: Text("Recipe created")));
      print(response.data);
     return true;
    } else {

      ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context).showSnackBar(SnackBar(content: Text("Recipe error : ${response.error}")));
      return false;
    }
  }




  Future<void> shareNFT()async{
    String url = generateEaselLink();
    log(url);

    Share.share(url, subject: 'My Easel NFT');

  }

  String generateEaselLink(){
    return Uri.parse("http://wallet.pylons.tech/?action=purchase_nft&recipe_id=$_recipeId&cookbook_id=$_cookbookId&nft_amount=1").toString();
  }

  @override
  void dispose(){
    artistNameController.dispose();
    artNameController.dispose();
    descriptionController.dispose();
    noOfEditionController.dispose();
    royaltyController.dispose();
    super.dispose();
  }


}