import 'package:flutter/material.dart';
import 'package:sambara/class/form_class.dart';

// nanti harusnya datanya nyambung dari form 1
class Form2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FormSTNK data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulir Perpanjangan"),
      ),
      body: ListView(
        children: [
          //Text('${data.toMap()}'),
          //SizedBox(height: 20,),
          //UploadImageDemo(),
        ],
      ),
    );
  }
}
