import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sambara/screens/form/form1.dart';
import 'package:sambara/screens/pdf_viewers.dart';
import 'package:sambara/screens/form/FormCekStatus.dart';

const String PanduanPDF = 'PDF/Panduan.pdf';
const String FAQPDF = 'PDF/FAQ.pdf';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<String> preparePdf(String _documentPath) async {
    final ByteData bytes =
        await DefaultAssetBundle.of(context).load(_documentPath);
    final Uint8List list = bytes.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$_documentPath';
    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);
    return tempDocumentPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('Gambar/atas.jpg', fit: BoxFit.cover, height: 50.0),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(children: <Widget>[
                    TextButton(
                        child: Image.asset(
                          'Gambar/Pengisian Form.jpg',
                          height: 150.0,
                          width: 150.0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Form1(),
                            ),
                          );
                        }),
                    Text('Pengisian Form')
                  ]),
                  Column(children: <Widget>[
                    TextButton(
                        child: Image.asset(
                          'Gambar/Cek Status.jpg',
                          height: 150.0,
                          width: 150.0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormCekStatus(),
                            ),
                          );
                        }),
                    Text('Cek Status')
                  ]),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(children: <Widget>[
                    TextButton(
                      child: Image.asset(
                        'Gambar/Bantuan.jpg',
                        height: 150.0,
                        width: 150.0,
                      ),
                      onPressed: () {
                        preparePdf(FAQPDF).then((path) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewer(
                                path: path,
                                title: "Frequently Asked Questions",
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    Text('Bantuan'),
                  ]),
                  Column(children: <Widget>[
                    TextButton(
                      child: Image.asset(
                        'Gambar/Panduan.jpg',
                        height: 150.0,
                        width: 150.0,
                      ),
                      onPressed: () {
                        preparePdf(PanduanPDF).then((path) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewer(
                                path: path,
                                title: "Panduan Perpanjangan",
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    Text('Panduan')
                  ]),
                ]),
          ],
        ),
      ),
    );
  }
}
