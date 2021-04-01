import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sambara/class/form_class.dart';
import 'package:sambara/screens/form/FormCekStatus.dart';

class CekStatus extends StatefulWidget {
  @override
  CekStatusState createState() {
    return CekStatusState();
  }
}

class CekStatusState extends State<CekStatus> {
  Widget showStatus() {
    return FutureBuilder<FormSTNK>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final identitas = snapshot.data;
            if (identitas.sudahBayar == true) {
              return Container(
                  padding: EdgeInsets.all(30.0),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        "Pendaftaran anda sudah terverifikasi",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ));
            } else if (identitas.sudahBayar == false) {
              return Container(
                  padding: EdgeInsets.all(30.0),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        "Pendaftaran anda belum terverifikasi",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ));
            }
          } else if (snapshot.hasError) {
            return Container(
                padding: EdgeInsets.all(30.0),
                child: ListView(
                  children: <Widget>[
                    Text(
                      "NRKB tidak terdaftar",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ));
          }
          return CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cek Status Pendaftaran"),
        ),
        body: showStatus());
  }
}

Future<FormSTNK> getData() async {
  final url = "https://stnk-api-ta.tech/api/perpanjangan?nrkb=${data.nrkb}";
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return FormSTNK.fromJson(jsonData[0]);
  } else {
    throw Exception();
  }
}
