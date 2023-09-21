const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// create Schema
const VerifyDataSchema = new Schema({
  nik: {
    type: String,
    required: [true, 'nik field is required']
  },
  nama: {
    type: String,
    required: [true, 'nama field is required']
  },
  alamat: {
    type: String,
    required: [true, 'alamat field is required']
  },
  nrkb: {
    type: String,
    required: [true, 'nrkb field is required']
  },
  jenisKendaraan: {
    type: String,
    required: [true, 'jenisKendaraan field is required']
  },
  noRangka: {
    type: String,
    required: [true, 'noRangka field is required']
  }
});

const VerifyData = mongoose.model('verifydata', VerifyDataSchema);
module.exports = VerifyData;
