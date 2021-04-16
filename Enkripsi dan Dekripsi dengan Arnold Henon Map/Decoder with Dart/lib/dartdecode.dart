import 'package:http/http.dart' as http;
import 'package:image/image.dart' as im;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

im.Image readImage(String path) {
  var imageData = File(path).readAsBytesSync();
  List<int> bytes = Uint8List.view(imageData.buffer);
  var image = im.decodePng(bytes);
  return image;
}

Future<List> fetchMap({int width, int height}) async {
  // print('\nFetching Map...');
  var authority = 'stnk-api-ta.tech';
  var unencodedPath = 'api/map';
  var queryParameters = {
    'q': 'H',
    'width': width.toString(),
    'height': height.toString(),
  };
  var res =
      await http.get(Uri.https(authority, unencodedPath, queryParameters));
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print('Status Code ' + res.statusCode.toString());
    List tmpmap = json.decode(res.body);
    var onelist = [];
    tmpmap.forEach((e) => onelist.addAll(e));
    // print('width = $width');
    // print('height = $height');
    // print('width x height = ' + onelist.length.toString());
    // print('Fetching done\n');
    return onelist;
  } else {
    // print(res.statusCode);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load map');
  }
}

im.Image mapping(im.Image src, List map) {
  print('Mapping...');
  final p = src.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    final l = map[i ~/ 4];
    p[i] = p[i] ^ l;
    p[i + 1] = p[i + 1] ^ l;
    p[i + 2] = p[i + 2] ^ l;
  }
  print('Mapping done\n');
  return src;
}

Future<Map> fetchData({String nrkb}) async {
  print('\nFetching Data...');
  var authority = 'stnk-api-ta.tech';
  var unencodedPath = 'api/perpanjangan';
  var queryParameters = {'nrkb': nrkb};
  var res =
      await http.get(Uri.https(authority, unencodedPath, queryParameters));
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Status Code ' + res.statusCode.toString());
    List tmp = json.decode(res.body);
    if (tmp.isEmpty) {
      throw Exception('Data not found');
    }
    ;
    Map tmpmap = tmp[0];
    print('id = ${tmpmap['_id']}');
    print('nrkb = ${tmpmap['nrkb']}');
    print('fotoKTP ${tmpmap['fotoKTP'] != null ? 'exist' : 'null'}');
    print('fotoBPKB ${tmpmap['fotoBPKB'] != null ? 'exist' : 'null'}');
    print('fotoSTNK ${tmpmap['fotoSTNK'] != null ? 'exist' : 'null'}');
    print('fotoNomorRangka ${tmpmap['fotoSTNK'] != null ? 'exist' : 'null'}');
    return tmpmap;
  } else {
    print(res.statusCode);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load map');
  }
}

void imageSaver(String filename, Map data, List map) async {
  var byte = base64Decode(data[filename]);
  var dir = 'result/${data['nrkb']}';
  var enPath = '$dir/en/$filename.png';
  var dePath = '$dir/de/$filename.png';
  await File(enPath)
      .create(recursive: true)
      .then((File file) => file.writeAsBytesSync(byte));
  var image = readImage(enPath);
  var mapped = mapping(image, map);
  await File(dePath)
      .create(recursive: true)
      .then((File file) => file.writeAsBytesSync(im.encodePng(mapped)));
  print('$filename saved to \"$enPath\"');
  print('decrypted $filename saved to \"$dePath\"\n');
}
