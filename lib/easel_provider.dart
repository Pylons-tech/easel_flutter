import 'dart:io';

import 'package:easel_flutter/utils/file_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EaselProvider extends ChangeNotifier {
  File? _file;
  String _fileName = "";
  String _fileExtension = "";
  String _fileSize = "0";

  File? get file => _file;
  String get fileName => _fileName;
  String get fileExtension => _fileExtension;
  String get fileSize => _fileSize;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final artistNameController = TextEditingController();
  final artNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final noOfEditionController = TextEditingController();
  final royaltyController = TextEditingController();

  initStore(){
    _file = null;
   _fileName = "";
   _fileSize = "0";

   artistNameController.clear();
   artNameController.clear();
   descriptionController.clear();
   noOfEditionController.clear();
   royaltyController.clear();
   formKey.currentState?.reset();
   notifyListeners();
  }

  void setFile(PlatformFile selectedFile){
    _file = File(selectedFile.path!);
    _fileName = selectedFile.name;
    _fileSize = FileUtils.getFileSizeInMB(_file!.lengthSync()).toStringAsFixed(2);
    _fileExtension = FileUtils.getExtension(_fileName);
    notifyListeners();
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