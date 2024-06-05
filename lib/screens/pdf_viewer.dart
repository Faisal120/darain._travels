import 'dart:io';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFOpener extends StatefulWidget{
  String url;
  PDFOpener(this.url, {super.key});

  @override
  State<PDFOpener> createState() => _PDFOpenerState();
}

class _PDFOpenerState extends State<PDFOpener> {
  late File pFile;
  bool isLoading = false;
  var image;

  Future<void> loadUrl() async{
    try{
      setState(() {
        isLoading = true;
      });
      final response = await http.get(Uri.parse(widget.url));
      final bytes = response.bodyBytes;
      final fileName = basename(widget.url);
      final dir = await getApplicationDocumentsDirectory();
      var file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      // final thumbnail = await FilePreview.getThumbnail(file.path);
      setState(() {
        pFile = file;
        // image = thumbnail;
      });
      print('FilePath: $pFile');
      setState(() {
        isLoading= false;
      });

    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    loadUrl();
    print('url: ${widget.url}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text(''),
        backButton: true,
      ),
      body: isLoading? const Center(child: CircularProgressIndicator())
          : Center(
            child: widget.url.contains('.pdf')? PDFView(
              filePath: pFile.path,
              fitPolicy: FitPolicy.BOTH,
            ):Image.network(widget.url),
          ),
    );
  }
}