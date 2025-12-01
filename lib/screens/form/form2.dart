import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sambara/class/form_class.dart';
import 'package:sambara/screens/form/form1.dart';
import 'package:sambara/screens/form/form3.dart';

class Http extends StatefulWidget {
  @override
  HttpState createState() {
    return HttpState();
  }
}

class HttpState extends State<Http> {
  Widget showData() {
    return FutureBuilder<FormSTNK>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final identitas = snapshot.data;
            return Container(
                padding: EdgeInsets.all(30.0),
                child: ListView(
                  children: <Widget>[
                    Card(
                      child: Text(
                          " NIK : ${identitas?.nik} \n Nama : ${identitas?.nama} \n NRKB : ${identitas?.nrkb} \n Alamat : ${identitas?.alamat} \n Jenis Kendaraan : ${identitas?.jenisKendaraan} \n Nomor Rangka : ${identitas?.noRangka}"),
                    ),
                    OutlinedButton(
                        child: Text('Lanjutkan ke Upload Gambar'),
                        onPressed: () {
                          print('Http->Form3, data: ${data.toString()}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Verifikasi Identitas"),
        ),
        body: showData());
  }
}

Future<FormSTNK> getData() async {
  final url =
      "https://stnk-api-ta.tech/api/verify?nrkb=${data.nrkb}&nik=${data.nik}";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return FormSTNK.fromJson(jsonData[0]);
  } else {
    throw Exception();
  }
}
