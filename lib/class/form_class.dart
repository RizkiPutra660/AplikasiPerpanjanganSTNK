class FormSTNK {
  String nrkb,
      nama,
      nik,
      alamat,
      jenisKendaraan,
      noRangka,
      noTelp,
      fotoKTP,
      fotoBPKB,
      fotoSTNK,
      fotoNomorRangka,
      id;
  bool sudahBayar;

  FormSTNK(
      {this.nrkb,
      this.nama,
      this.nik,
      this.alamat,
      this.jenisKendaraan,
      this.noRangka,
      this.noTelp,
      this.fotoKTP,
      this.fotoBPKB,
      this.fotoSTNK,
      this.fotoNomorRangka,
      this.sudahBayar,
      this.id});

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
      'nrkb': nrkb,
      'nama': nama,
      'nik': nik,
      'alamat': alamat,
      'jenisKendaraan': jenisKendaraan,
      'noRangka': noRangka,
      'noTelp': noTelp,
      'fotoKTP': fotoKTP,
      'fotoBPKB': fotoBPKB,
      'fotoSTNK': fotoSTNK,
      'fotoNomorRangka': fotoNomorRangka,
      'id': id,
    };
  }

  String toString({bool nice = true}) {
    if (nice) {
      return "NRKB: $nrkb,\nNamaPemilik: $nama,\nNIK/TDP: $nik,\nAlamat: $alamat,\nJenis Kendaraan: $jenisKendaraan,\nNo. Rangka: $noRangka";
    }
    return "NRKB: $nrkb, NamaPemilik: $nama, NIK/TDP: $nik, Alamat: $alamat, Jenis Kendaraan: $jenisKendaraan, No. Rangka: $noRangka";
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
      sudahBayar: json['sudahBayar'],
      id: json['_id'],
    );
  }
}
