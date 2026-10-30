import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

Future<String> savePhoto(String itemId, Uint8List bytes) async {
  final dir = Directory('${(await getApplicationDocumentsDirectory()).path}/photos');
  await dir.create(recursive: true);
  final file = File('${dir.path}/$itemId.jpg');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

ImageProvider photoProvider(String ref) => FileImage(File(ref));
