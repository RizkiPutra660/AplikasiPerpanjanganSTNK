//Upload NomorRangka
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:sambara/class/form_class.dart';
import 'package:sambara/class/endpoint.dart';
import 'package:sambara/screens/SelesaiPendaftaran.dart';
import 'package:sambara/mapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as im;

late Directory directory;
late String appDocumentsDirectory;
late String savepath;
late String mappedsavepath;
String baseurl = Endpoint().endpoint;
late Future<List> futureMap;
String filecache = "cache4.png";
String mappedcache = "cacheM4.png";
bool isVisible = false;
String ambilTeks = 'Ambil Foto Nomor Rangka';

class Form6 extends StatefulWidget {
  Form6() : super();
  final String title = "Upload Image Demo";
  @override
  Form6State createState() => Form6State();
}

class Form6State extends State<Form6> {
  static final String uploadEndPoint = "$baseurl/api/perpanjangan";
  Future<File>? fileNomorRangka;
  String status = '';
  String? base64NomorRangka;
  File? tmpFile;
  String errMessage = 'Pengunggahan Gambar Gagal';
  String succMessage = 'Gambar Berhasil Diunggah';
  List? users;
  bool isLoading = false;

  chooseImage() async {
    final picker = ImagePicker();
    setState(() {
      fileNomorRangka = picker.pickImage(
          source: ImageSource.camera, maxHeight: 300, maxWidth: 400).then((xfile) => xfile != null ? File(xfile.path) : throw Exception('No image'));
      isVisible = true;
      ambilTeks = 'Ambil Ulang Foto Nomor Rangka';
    });
    setStatus('');

    await getTemporaryDirectory().then((value) => directory = value);
    appDocumentsDirectory = directory.path;
    print(appDocumentsDirectory);
    savepath = appDocumentsDirectory + "/" + filecache;
    mappedsavepath = appDocumentsDirectory + "/" + mappedcache;
    print(savepath);
    print(mappedsavepath);

    await fileNomorRangka!.then((value) => tmpFile = value);
    final decodedImage = im.decodeImage(tmpFile!.readAsBytesSync());
    if (decodedImage == null) return;
    im.Image image = im.grayscale(decodedImage);
    File(savepath).writeAsBytesSync(im.encodePng(image));
    List? mapNullable;
    await futureMap.then((value) => mapNullable = value);
    if (mapNullable == null) return;
    final List map = mapNullable as List;
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
    final FormSTNK data = ModalRoute.of(context)?.settings.arguments as FormSTNK;

    Widget showImage(file) {
      return FutureBuilder<File>(
        future: file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            tmpFile = snapshot.data!;
            data.fotoNomorRangka =
                base64Encode(File(mappedsavepath).readAsBytesSync());
            // data.fotoNomorRangka = base64Encode(snapshot.data.readAsBytesSync());
            return Image.file(
              snapshot.data!,
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
      floatingActionButton: Visibility(
        visible: isVisible,
        child: FloatingActionButton.extended(
            label: Text('Upload Data'),
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Selesai(),
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

          // Foto NomorRangka
          OutlinedButton(
            onPressed: () async {
              await chooseImage();
            },
            child: Text(ambilTeks),
          ),
          SizedBox(
            height: 20.0,
          ),
          showImage(fileNomorRangka),
          SizedBox(
            height: 20.0,
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
