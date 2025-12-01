import 'package:flutter/material.dart';
import 'package:sambara/screens/home.dart';
import 'package:sambara/class/form_class.dart';
import 'package:sambara/class/endpoint.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String baseurl = Endpoint().endpoint;
String uploadEndPoint = "$baseurl/api/perpanjangan";
late List<dynamic> users;
final routes = {'/home': (BuildContext context) => new Home()};

class Selesai extends StatefulWidget {
  @override
  SelesaiState createState() {
    return SelesaiState();
  }
}

class SelesaiState extends State<Selesai> {
  @override
  Widget build(BuildContext context) {
    final FormSTNK data = ModalRoute.of(context)?.settings.arguments as FormSTNK;
    return Scaffold(
      appBar: AppBar(
        title: Text("Selesai Pendaftaran"),
        centerTitle: true,
      ),
      body: showData(data),
    );
  }

  Widget uploadSelesai() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Image.asset('Gambar/Finish.gif'),
          Text(
              ' Pendaftaran anda sudah selesai \n Silahkan klik menu "Cek Status" pada halaman utama secara berkala',
              textAlign: TextAlign.center),
          OutlinedButton(
              child: Text('Kembali ke Halaman Utama'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              }),
        ]));
  }

  Widget uploadLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
            Text(
              "Sedang Mengunggah...",
              textAlign: TextAlign.center,
            )
          ],
        )
      ],
    );
  }

  Widget showData(FormSTNK data) {
    Future<List> fetchUser() async {
      var url = "$baseurl/api/perpanjangan?nrkb=${data.nrkb}";
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var items = json.decode(response.body);
        return items as List<dynamic>;
      } else {
        return <dynamic>[];
      }
    }

    Future<FormSTNK> postData() async {
      var response;
      print('Start uploading');
      await fetchUser().then((value) => users = value);
      print('Fetching user');
      print(users.isEmpty);
      if (users.isEmpty) {
        response = await http.post(
          Uri.parse(uploadEndPoint),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data.toMap()),
        );
      } else {
        response = await http.put(
          Uri.parse("$uploadEndPoint/${users[0]['_id']}") ,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data.toMap()),
        );
      }
      print('Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return FormSTNK.fromJson(jsonData);
      } else {
        throw Exception();
      }
    }

    return FutureBuilder<FormSTNK>(
        future: postData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return uploadSelesai();
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Upload Error, silahkan mengupload kembali",
                      textAlign: TextAlign.center,
                    ),
                    OutlinedButton(
                        child: (Text('Upload Ulang')),
                        onPressed: () {
                          setState(() {});
                        }),
                  ],
                )
              ],
            );
          }
          return uploadLoading();
        });
  }
}
