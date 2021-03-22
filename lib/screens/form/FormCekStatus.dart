// Isi Identitas
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sambara/class/form_class.dart';
import 'package:sambara/screens/CekStatus.dart';

FormSTNK data = FormSTNK();

// Define a custom Form widget.
class FormCekStatus extends StatefulWidget {
  @override
  FormCekStatusState createState() {
    return FormCekStatusState();
  }
}

class FormCekStatusState extends State<FormCekStatus> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Cek Status Pendaftaran"),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.navigate_next),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print("${data.nrkb}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CekStatus(),
                      settings: RouteSettings(
                        arguments: data,
                      ),
                    ),
                  );
                }
              }),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Registrasi Kendaraan Bermotor',
                    hintText: 'Masukkan NRKB yang ingin dicek',
                  ),
                  onChanged: (val) {
                    setState(() {
                      data.nrkb = val;
                    });
                  },
                  validator: (String val) {
                    // return val.contains('@') ? 'Do not use the @ char.' : null;
                    Pattern pat = r'^[A-Z]{1,2}\s[1-9][0-9]{1,3}\s[A-Z]{1,3}$';
                    RegExp regex = new RegExp(pat);
                    if (!regex.hasMatch(val))
                      return 'Nomor tidak valid';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
