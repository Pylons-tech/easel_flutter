import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfViewer extends StatefulWidget {
  final File? file;

  const PdfViewer({Key? key, required this.file}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {

  late PDFDocument doc ;
  bool _isLoading=true;

  @override
  void initState() {
    initializeDoc();
    super.initState();
  }

  Future initializeDoc() async{
 doc = await PDFDocument.fromFile(widget.file!);
    _isLoading=false;
    setState((){
    });

  }
  @override
  Widget build(BuildContext context) {

    return Center(
        child: _isLoading
        ? const Center(child: CircularProgressIndicator())
    :  PDFViewer(document: doc));
  }
}
