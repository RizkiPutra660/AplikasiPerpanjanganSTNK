// Isi Identitas
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sambara/class/form_class.dart';
import 'package:sambara/screens/Http.dart';

FormSTNK data = FormSTNK();

class Form1 extends StatefulWidget {
  @override
  Form1State createState() {
    return Form1State();
  }
}

class Form1State extends State<Form1> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Formulir Perpanjangan"),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.navigate_next),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print('Form1->Form3, data: ${data.toString()}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Http(),
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
                    hintText: 'contoh: B 123 CDE',
                  ),
                  onChanged: (val) {
                    setState(() {
                      data.nrkb = val;
                    });
                  },
                  validator: (String val) {
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
                // TextFormField(
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   decoration: const InputDecoration(
                //     labelText: 'Nama Pemilik',
                //     hintText: 'Sesuaikan dengan STNK',
                //   ),
                //   onChanged: (val) {
                //     setState(() {
                //       data.nama = val;
                //     });
                //   },
                //   validator: (val) {
                //     if (val.isEmpty) {
                //       return 'Tidak boleh kosong';
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'NIK',
                    // hintText: '',
                  ),
                  onChanged: (val) {
                    setState(() {
                      data.nik = val;
                    });
                  },
                  validator: (val) {
                    if (val.length != 16) {
                      return 'NIK tidak sesuai (Harus terdiri dari 16 angka)';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // TextFormField(
                //     autovalidateMode: AutovalidateMode.onUserInteraction,
                //     keyboardType: TextInputType.number,
                //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //     decoration: const InputDecoration(
                //       labelText: 'Nomor Telepon/HP',
                //       hintText: 'contoh: 0222500935 atau 085814140041',
                //     ),
                //     onChanged: (val) {
                //       setState(() {
                //         data.noTelp = val;
                //       });
                //     },
                //     validator: (String val) {
                //       // return val.contains('@') ? 'Do not use the @ char.' : null;
                //       Pattern pat = r'(^[0-9]{10,12}$)';
                //       RegExp regex = new RegExp(pat);
                //       if (val.isEmpty) {
                //         return 'Masukkan Nomor Telepon/HP';
                //       } else if (!regex.hasMatch(val)) {
                //         return 'Nomor Telepon/HP tidak valid';
                //       }
                //       return null;
                //     }),
              ],
            ),
          ),
        ));
  }
}
