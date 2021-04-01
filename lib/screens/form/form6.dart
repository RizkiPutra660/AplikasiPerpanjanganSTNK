//Upload NomorRangka
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sambara/class/form_class.dart';
import 'package:sambara/class/endpoint.dart';
final baseurl = Endpoint().endpoint;

class Form6 extends StatefulWidget {
  Form6() : super();
  final String title = "Upload Image Demo";
  @override
  Form6State createState() => Form6State();
}

class Form6State extends State<Form6> {
  static final String uploadEndPoint = "$baseurl/api/perpanjangan";
  Future<File> fileNomorRangka;
  String status = '';
  String base64NomorRangka;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      fileNomorRangka = ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 300, maxWidth: 400);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FormSTNK data = ModalRoute.of(context).settings.arguments;
    upload() {
      print('start uploading');
      // print(data.toMap());
      setStatus('Start Uploading...');
      http
          .post(
        uploadEndPoint,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data.toMap()),
      )
          .then((result) {
        print(result.statusCode);
        setStatus(result.statusCode == 200 ? "NOICE" : errMessage);
        // setStatus(result.body);
      }).catchError((error) {
        setStatus(error);
      });
    }

    Widget showImage(file) {
      return FutureBuilder<File>(
        future: file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            tmpFile = snapshot.data;
            data.fotoNomorRangka =
                base64Encode(snapshot.data.readAsBytesSync());

            return Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            );
          } else if (null != snapshot.error) {
            return Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            );
          } else {
            return Text(
              'No Image Selected',
              textAlign: TextAlign.center,
            );
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload NomorRangka"),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          // placeholder
          Card(
            child: Text('${data.toString()}'),
          ),
          SizedBox(
            height: 20.0,
          ),

          // Foto NomorRangka
          OutlinedButton(
            onPressed: () {
              chooseImage();
            },
            child: Text('Pilih Foto NomorRangka'),
          ),
          SizedBox(
            height: 20.0,
          ),
          showImage(fileNomorRangka),
          SizedBox(
            height: 20.0,
          ),

          // Upload
          OutlinedButton(
            onPressed: () {
              upload();
            },
            child: Text('Upload Image'),
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
    );
  }
}
