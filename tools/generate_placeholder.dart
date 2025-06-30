import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() async {
  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  final size = Size(512, 512);
  final rect = Offset.zero & size;

  // Draw background
  final paint = Paint()..color = const Color(0xFFfda609);
  canvas.drawRect(rect, paint);

  // Draw text
  final textPainter = TextPainter(
    text: TextSpan(
      text: 'WERU\nDIGITAL',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 64,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        height: 1.2,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  );

  textPainter.layout(maxWidth: size.width * 0.9);
  textPainter.paint(
    canvas,
    Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    ),
  );

  // Convert to image and save
  final picture = pictureRecorder.endRecording();
  final img = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  // Save the image
  final file = File('assets/images/radio_logo.png');
  await file.writeAsBytes(buffer);

  debugPrint('Generated placeholder image at: ${file.path}');
}
