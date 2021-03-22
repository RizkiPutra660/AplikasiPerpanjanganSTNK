// Upload KTP
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sambara/class/form_class.dart';
import 'package:sambara/screens/form/form1.dart';
import 'package:sambara/screens/form/form4.dart';

class Form3 extends StatefulWidget {
  Form3() : super();

  final String title = "Upload Image Demo";

  @override
  Form3State createState() => Form3State();
}

class Form3State extends State<Form3> {
  //
  static final String uploadEndPoint =
      'https://stnk-api-ta.tech/api/perpanjangan';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Gambar gagal diunggah';
  String succMessage = 'Gambar berhasil diunggah';

  chooseImage() {
    setState(() {
      // ignore: deprecated_member_use
      file = ImagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 95,
          maxHeight: 1000,
          maxWidth: 1000);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = data.nrkb;
    upload(fileName);
  }

  upload(String fileName) {
    http
        .post(uploadEndPoint,
            headers: {"Content-type": "application/json"},
            body: jsonEncode({
              "fotoKTP": base64Image,
              "nrkb": fileName,
            }))
        .then((result) {
      setStatus(result.statusCode == 200 ? succMessage : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FormSTNK data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload KTP"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.navigate_next),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Form4(),
                settings: RouteSettings(
                  arguments: data,
                ),
              ),
            );
          }),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            // placeholder
            Card(
              child: Text('${data.toMap()}'),
            ),
            SizedBox(
              height: 20.0,
            ),
            OutlinedButton(
              onPressed: chooseImage,
              child: Text('Ambil Gambar'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            OutlinedButton(
              onPressed: startUpload,
              child: Text('Unggah Gambar'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
