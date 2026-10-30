import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

typedef ImageSharer = Future<void> Function(GlobalKey boundary, String text);

/// Turns the widget under [boundary] into a PNG and opens the share sheet
/// (WhatsApp, Instagram, …). Tests replace it to skip the platform call.
ImageSharer shareImage = _shareImage;

Future<void> _shareImage(GlobalKey boundary, String text) async {
  final render = boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await render.toImage(pixelRatio: 3);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  final bytes = data!.buffer.asUint8List();
  await SharePlus.instance.share(
    ShareParams(
      text: text,
      files: [XFile.fromData(bytes, mimeType: 'image/png', name: 'talla-poll.png')],
    ),
  );
}
