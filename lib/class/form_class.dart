class FormSTNK {
  String nrkb;
  String nama;
  // ignore: non_constant_identifier_names
  String nik;
  String alamat;
  String jenisKendaraan;
  String noRangka;
  String noTelp;
  String fotoKTP;
  String fotoSTNK;
  String fotoBPKB;
  String fotoNomorRangka;
  bool sudahBayar;

  FormSTNK({
    this.nrkb,
    this.nama,
    // ignore: non_constant_identifier_names
    this.nik,
    this.alamat,
    this.jenisKendaraan,
    this.noRangka,
    this.noTelp,
    this.fotoKTP,
    this.fotoSTNK,
    this.fotoBPKB,
    this.fotoNomorRangka,
    this.sudahBayar,
  });

  bool isFull() {
    int _cnt = 0;
    Map _tempMap = this.toMap();
    _tempMap.forEach((k, v) {
      if (v == null) {
        _cnt += 1;
      }
    });
    return (_cnt == 0);
  }

  Map toMap() {
    return {
      'NRKB': nrkb,
      'NamaPemilik': nama,
      'NIK/TDP': nik,
      'No Telp': noTelp,
      'Foto KTP': fotoKTP,
    };
  }

  factory FormSTNK.fromJson(Map<String, dynamic> json) {
    return FormSTNK(
        nrkb: json['nrkb'],
        nama: json['nama'],
        nik: json['nik'],
        alamat: json['alamat'],
        jenisKendaraan: json['jenisKendaraan'],
        noRangka: json['noRangka'],
        noTelp: json['noTelp'],
        fotoKTP: json['fotoKTP'],
        fotoBPKB: json['fotoBPKB'],
        fotoNomorRangka: json['fotoNomorRangka'],
        fotoSTNK: json['fotoSTNK'],
        sudahBayar: json['sudahBayar']);
  }
}
