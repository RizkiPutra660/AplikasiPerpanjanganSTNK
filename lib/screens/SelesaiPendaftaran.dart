import 'package:flutter/material.dart';
import 'package:sambara/screens/home.dart';

class Selesai extends StatefulWidget {
  @override
  SelesaiState createState() {
    return SelesaiState();
  }
}

class SelesaiState extends State<Selesai> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Selesai Pendaftaran"),
          centerTitle: true,
        ),
        body: Center(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                        settings: RouteSettings(),
                      ),
                    );
                  }),
            ])));
  }
}
