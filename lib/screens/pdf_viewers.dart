import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PDFViewer extends StatelessWidget {
  final String path;
  final String title;

  PDFViewer({this.path, this.title});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        path: path);
  }
}