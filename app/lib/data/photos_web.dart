import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

Future<String> savePhoto(String itemId, Uint8List bytes) async => 'data:image/jpeg;base64,${base64Encode(bytes)}';

ImageProvider photoProvider(String ref) => MemoryImage(base64Decode(ref.substring(ref.indexOf(',') + 1)));
