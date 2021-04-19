//Upload STNK
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:sambara/class/form_class.dart';
import 'package:sambara/screens/form/Form6.dart';
import 'package:sambara/class/endpoint.dart';
import 'package:sambara/mapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as im;

Directory directory;
String appDocumentsDirectory;
String savepath;
String mappedsavepath;
String baseurl = Endpoint().endpoint;
Future<List> futureMap;
String filecache = "cache3.png";
String mappedcache = "cacheM3.png";
bool isVisible = false;
String ambilTeks = 'Ambil Foto STNK';

class Form5 extends StatefulWidget {
  Form5() : super();
  final String title = "Upload Image Demo";
  @override
  Form5State createState() => Form5State();
}

class Form5State extends State<Form5> {
  static final String uploadEndPoint = "$baseurl/api/perpanjangan";
  Future<File> fileSTNK;
  String status = '';
  String base64STNK;
  File tmpFile;
  String errMessage = 'Pengunggahan Gambar Gagal';
  String succMessage = 'Gambar Berhasil Diunggah';
  List users;
  bool isLoading = false;

  chooseImage() async {
    setState(() {
      fileSTNK = ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 300, maxWidth: 400);
      isVisible = true;
      ambilTeks = 'Ambil Ulang Foto STNK';
    });
    setStatus('');

    await getTemporaryDirectory().then((value) => directory = value);
    appDocumentsDirectory = directory.path;
    print(appDocumentsDirectory);
    savepath = appDocumentsDirectory + "/" + filecache;
    mappedsavepath = appDocumentsDirectory + "/" + mappedcache;
    print(savepath);
    print(mappedsavepath);

    await fileSTNK.then((value) => tmpFile = value);
    im.Image image = im.grayscale(im.decodeImage(tmpFile.readAsBytesSync()));
    File(savepath).writeAsBytesSync(im.encodePng(image));
    List map;
    await futureMap.then((value) => map = value);
    im.Image mapped = mapping(image, map);
    File(mappedsavepath).writeAsBytesSync(im.encodePng(mapped));
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  @override
  void initState() {
    super.initState();
    print("init");
    // fetchMap().then((value) => futureMap = value);
    futureMap = fetchMap();
    baseurl = Endpoint().endpoint;
  }

  Widget build(BuildContext context) {
    final FormSTNK data = ModalRoute.of(context).settings.arguments;

    Widget showImage(file) {
      return FutureBuilder<File>(
        future: file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            tmpFile = snapshot.data;
            data.fotoSTNK =
                base64Encode(File(mappedsavepath).readAsBytesSync());
            // data.fotoSTNK = base64Encode(snapshot.data.readAsBytesSync());
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
        title: Text("Upload STNK"),
      ),
      floatingActionButton: Visibility(
        visible: isVisible,
        child: FloatingActionButton.extended(
            icon: Icon(Icons.navigate_next),
            label: Text('Selanjutnya'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Form6(),
                  settings: RouteSettings(
                    arguments: data,
                  ),
                ),
              );
            }),
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

          // Foto STNK
          OutlinedButton(
            onPressed: () async {
              await chooseImage();
            },
            child: Text(ambilTeks),
          ),
          SizedBox(
            height: 20.0,
          ),
          showImage(fileSTNK),
          SizedBox(
            height: 20.0,
          ),

          // Upload
          // OutlinedButton(
          //   onPressed: () {
          //     upload();
          //   },
          //   child: Text('Unggah Gambar'),
          // ),
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
