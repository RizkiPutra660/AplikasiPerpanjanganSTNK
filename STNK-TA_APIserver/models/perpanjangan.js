const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// create Schema
const PerpanjanganSchema = new Schema({
  nrkb: {
    type: String,
    required: [true, 'nrkb field is required']
  },
  sudahBayar: {
    type: Boolean,
    default: false,
    required: [true, 'sudahBayar field is required']
  },
  fotoKTP: {
    type: String
  },
  fotoSTNK: {
    type: String
  },
  fotoBPKB: {
    type: String
  },
  fotoNomorRangka: {
    type: String
  }
});

const Perpanjangan = mongoose.model('Perpanjangan', PerpanjanganSchema);
module.exports = Perpanjangan;
