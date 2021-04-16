import 'package:dartdecode/dartdecode.dart' as dartdecode;
import 'dart:io';

String path = 'bin/image.png';
String savepath = 'bin/mappedEn_De.png';

void main(List<String> arguments) async {
  var tmpmap = dartdecode.fetchMap(width: 400, height: 300);
  var data;
  var map;

  stdout.write('NRKB: ');
  var nrkb = stdin.readLineSync();

  try {
    await dartdecode.fetchData(nrkb: nrkb).then((value) => data = value);
  } catch (e) {
    print('\n$e\n');
    return;
  }
  ;
  await tmpmap.then((value) => map = value);
  dartdecode.imageSaver('fotoKTP', data, map);
  dartdecode.imageSaver('fotoSTNK', data, map);
  dartdecode.imageSaver('fotoBPKB', data, map);
  dartdecode.imageSaver('fotoNomorRangka', data, map);
}
