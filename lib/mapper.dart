import 'package:http/http.dart' as http;
import 'package:image/image.dart' as im;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:sambara/class/endpoint.dart';
final baseurl = Endpoint().endpoint;

im.Image? readImage(String path) {
  var imageData = File(path).readAsBytesSync();
  Uint8List bytes = Uint8List.view(imageData.buffer);
  var image = im.decodePng(bytes);
  return image;
}

Future<List> fetchMap({int width = 400, int height = 300}) async {

  print('Fetching Map...');
  String mapEndPoint = "$baseurl/api/map?q=H&width=$width&height=$height";


  var res = await http.get(Uri.parse(mapEndPoint));
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Status Code ' + res.statusCode.toString());
    List tmpmap = json.decode(res.body);
    var onelist = [];
    tmpmap.forEach((e) => onelist.addAll(e));
    print('width = $width');
    print('height = $height');
    print('width x height = ' + onelist.length.toString());
    print('Fetching done\n');
    return onelist;
  } else {
    print(res.statusCode);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
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
