# Aplikasi Perpanjangan STNK

Aplikasi mobile berbasis Flutter untuk mensimulasikan perpanjangan STNK (Surat Tanda Nomor Kendaraan) secara online dengan fitur enkripsi gambar menggunakan Arnold dan Henon Map untuk keamanan dokumen yang diunggah.

## 📋 Deskripsi

Aplikasi ini memungkinkan pengguna untuk:
- Mengisi formulir perpanjangan STNK secara digital
- Mengunggah foto dokumen (KTP, BPKB, STNK, Nomor Rangka)
- Verifikasi identitas otomatis
- Enkripsi gambar untuk keamanan data
- Cek status pendaftaran

## 🛠️ Teknologi yang Digunakan

- **Frontend**: Flutter (Dart)
- **Backend**: Node.js (Express)
- **Enkripsi**: Arnold Map & Henon Map
- **Database**: MongoDB (melalui API)
- **Image Processing**: image package (Dart), PIL (Python)

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat

- Flutter SDK (>=2.12.0)
- Dart SDK (>=2.12.0 <4.0.0)
- Android Studio / VS Code dengan Flutter extension
- Emulator Android atau perangkat fisik
- Node.js (untuk backend, opsional)
- Python 3.x (untuk CLI tools, opsional)

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone https://github.com/RizkiPutra660/AplikasiPerpanjanganSTNK.git
   cd AplikasiPerpanjanganSTNK
   ```

2. **Install dependencies Flutter**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   # Cek perangkat yang tersedia
   flutter devices
   
   # Jalankan di emulator/device
   flutter run
   
   # Atau jalankan dalam mode release
   flutter run --release
   ```

### Menjalankan Backend API (Opsional)

Jika ingin menjalankan server lokal:

```bash
cd STNK-TA_APIserver
npm install
node index.js
```

Kemudian update endpoint di `lib/class/endpoint.dart` ke `http://localhost:PORT`

## 📱 Fitur Aplikasi

### 1. Halaman Utama
- Menu Pengisian Form
- Menu Cek Status
- Menu Bantuan (FAQ)
- Menu Panduan

### 2. Pengisian Formulir
- **Form 1**: Input Nomor Registrasi Kendaraan Bermotor (NRKB) dan NIK
- **Verifikasi**: Validasi data dengan database kependudukan
- **Form 3-6**: Upload foto dokumen dengan enkripsi otomatis
  - Foto KTP
  - Foto BPKB
  - Foto STNK
  - Foto Nomor Rangka

### 3. Cek Status
- Input NRKB untuk mengecek status pendaftaran
- Notifikasi verifikasi administrator

### 4. Keamanan
- Enkripsi gambar menggunakan Arnold & Henon Map
- Transformasi gambar ke grayscale
- Mapping pixel dengan kunci kriptografi

## 🔐 Enkripsi Gambar

Aplikasi menggunakan kombinasi Arnold Map dan Henon Map untuk mengenkripsi gambar dokumen:

1. Gambar dikonversi ke grayscale
2. Matriks enkripsi di-generate dari server
3. Pixel gambar di-XOR dengan matriks enkripsi
4. Gambar terenkripsi disimpan dan dikirim ke server

## 🧪 Testing

Jalankan test dengan:

```bash
flutter test
```

## 🔧 Konfigurasi

### Endpoint API

Edit file `lib/class/endpoint.dart`:

```dart
class Endpoint {
  String endpoint = "https://stnk-api-ta.tech";
}
```

### Asset Gambar

Pastikan folder `Gambar/` dan `PDF/` berisi asset yang diperlukan:
- Gambar navigasi (Pengisian Form, Cek Status, dll)
- PDF Panduan
- PDF FAQ

## 👥 Kontributor

- [Muhammad Athallah Rizki Putra](https://www.linkedin.com/in/athallahrizki/)
- [Hafizh Mulya Harjono](https://www.linkedin.com/in/hafizh-mulya/)


**Note**: Aplikasi ini adalah simulasi dan bukan aplikasi resmi dari pemerintah. Digunakan untuk keperluan penelitian dan pembelajaran.
