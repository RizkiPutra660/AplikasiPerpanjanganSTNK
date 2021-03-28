import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sambara/class/form_class.dart';
import 'package:sambara/screens/form/form3.dart';

// final baseurl = "https://stnk-api-ta.tech";
final baseurl = "http://192.168.1.124:4000";

class Http extends StatefulWidget {
  @override
  HttpState createState() {
    return HttpState();
  }
}

class HttpState extends State<Http> {
  @override
  Widget build(BuildContext context) {
    final FormSTNK data = ModalRoute.of(context).settings.arguments;
    print(data.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text("Verifikasi Identitas"),
        ),
        body: showData(data));
  }

  Widget showData(data) {
    Future<FormSTNK> getData() async {
      final url = "$baseurl/api/verify?nrkb=${data.nrkb}&nik=${data.nik}";
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return FormSTNK.fromJson(jsonData[0]);
      } else {
        throw Exception();
      }
    }
    return FutureBuilder<FormSTNK>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            FormSTNK data = snapshot.data;
            return Container(
                padding: EdgeInsets.all(30.0),
                child: ListView(
                  children: <Widget>[
                    Card(
                      child: Text(
                          " NIK : ${data.nik} \n Nama : ${data.nama} \n NRKB : ${data.nrkb} \n Alamat : ${data.alamat} \n Jenis Kendaraan : ${data.jenisKendaraan} \n Nomor Rangka : ${data.noRangka}"),
                    ),
                    OutlinedButton(
                        child: Text('Lanjutkan ke Upload Gambar'),
                        onPressed: () {
                          print('Http->Form3, data:\n${data.toString()}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Form3(),
                              settings: RouteSettings(
                                arguments: data,
                              ),
                            ),
                          );
                        }),
                  ],
                ));
          } else if (snapshot.hasError) {
            return Text(
              "Identitas Anda tidak terdaftar dalam database kependudukan \n Cek kembali data dan koneksi internet Anda",
              textAlign: TextAlign.center,
            );
          }
          return CircularProgressIndicator();
        });
  }
}