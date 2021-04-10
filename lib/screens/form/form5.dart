//Upload STNK
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
String filecache="cache3.png";
String mappedcache="cacheM3.png";

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

  chooseImage() async{
    setState(() {
      fileSTNK = ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 300, maxWidth: 400);
    });
    setStatus('');

    await getTemporaryDirectory().then((value) => directory = value);
    appDocumentsDirectory = directory.path;
    print(appDocumentsDirectory);
    savepath =  appDocumentsDirectory + "/" + filecache;
    mappedsavepath =  appDocumentsDirectory + "/" + mappedcache;
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
    fetchUser() async {
      setState(() {
        isLoading = true;
      });
      var url = "$baseurl/api/perpanjangan?nrkb=${data.nrkb}";
      var response = await http.get(url);
      // print(response.body);
      if (response.statusCode == 200) {
        var items = json.decode(response.body);
        setState(() {
          return users = items;
          //isLoading = false;
        });
      } else {
        users = null;
        isLoading = false;
      }
    }

    upload() {
      fetchUser();
      print('start uploading');

      setStatus('Start Uploading...');
      if (users == null) {
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
          setStatus(result.statusCode == 200 ? succMessage : errMessage);
          // setStatus(result.body);
        }).catchError((error) {
          setStatus(error);
        });
      } else if (users != null) {
        http
            .put(
          "$baseurl/api/perpanjangan/${users[0]['_id']}",
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data.toMap()),
        )
            .then((result) {
          print(result.statusCode);
          setStatus(result.statusCode == 200 ? succMessage : errMessage);
          // setStatus(result.body);
        }).catchError((error) {
          setStatus(error);
        });
      }
    }

    Widget showImage(file) {
      return FutureBuilder<File>(
        future: file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            tmpFile = snapshot.data;
            data.fotoSTNK = base64Encode(File(mappedsavepath).readAsBytesSync());
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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.navigate_next),
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
            onPressed: () {
              chooseImage();
            },
            child: Text('Ambil Foto STNK'),
          ),
          SizedBox(
            height: 20.0,
          ),
          showImage(fileSTNK),
          SizedBox(
            height: 20.0,
          ),

          // Upload
          OutlinedButton(
            onPressed: () {
              upload();
            },
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
    );
  }
}
