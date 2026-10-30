import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'photos_web.dart' if (dart.library.io) 'photos_io.dart' as impl;

/// Saves a picked photo and returns the reference stored on the item: a file
/// path on phones, a data URI on the web build.
Future<String> savePhoto(String itemId, Uint8List bytes) => impl.savePhoto(itemId, bytes);

ImageProvider photoProvider(String ref) => impl.photoProvider(ref);
