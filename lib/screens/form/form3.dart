//Upload KTP
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:sambara/class/form_class.dart';
import 'package:sambara/screens/form/form4.dart';
import 'package:sambara/class/endpoint.dart';
import 'package:sambara/mapper.dart';
import 'package:image/image.dart' as im;
import 'package:path_provider/path_provider.dart';

late Directory directory;
late String appDocumentsDirectory;
late String savepath;
late String mappedsavepath;
String baseurl = Endpoint().endpoint;
late Future<List> futureMap;
String filecache = "cache1.png";
String mappedcache = "cacheM1.png";
bool isVisible = false;
String ambilTeks = 'Ambil Foto KTP';

class Form3 extends StatefulWidget {
  Form3() : super();
  final String title = "Upload Image Demo";
  @override
  Form3State createState() => Form3State();
}

class Form3State extends State<Form3> {
  static final String uploadEndPoint = "$baseurl/api/perpanjangan";
  Future<File>? fileKTP;
  String status = '';
  String? base64KTP;
  File? tmpFile;
  String errMessage = 'Pengunggahan Gambar Gagal';
  String succMessage = 'Gambar Berhasil Diunggah';
  List? users;
  bool isLoading = false;

  chooseImage() async {
    final picker = ImagePicker();
    setState(() {
      fileKTP = picker.pickImage(
          source: ImageSource.camera, maxHeight: 300, maxWidth: 400).then((xfile) => xfile != null ? File(xfile.path) : throw Exception('No image'));
      isVisible = true;
      ambilTeks = 'Ambil Ulang Foto KTP';
    });
    setStatus('');

    await getTemporaryDirectory().then((value) => directory = value);
    appDocumentsDirectory = directory.path;
    print(appDocumentsDirectory);
    savepath = appDocumentsDirectory + "/" + filecache;
    mappedsavepath = appDocumentsDirectory + "/" + mappedcache;
    print(savepath);
    print(mappedsavepath);

    await fileKTP!.then((value) => tmpFile = value);
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
            data.fotoKTP = base64Encode(File(mappedsavepath).readAsBytesSync());
            // data.fotoKTP = base64Encode(snapshot.data.readAsBytesSync());
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
        title: Text("Upload KTP"),
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
                  builder: (context) => Form4(),
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

          // Foto BPKB
          OutlinedButton(
            onPressed: () async {
              await chooseImage();
            },
            child: Text(ambilTeks),
          ),
          SizedBox(
            height: 20.0,
          ),
          showImage(fileKTP),
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
