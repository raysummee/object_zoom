import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImagePainter extends CustomPainter {
  ui.Image resImage;

  Rect rectCrop;

  ImagePainter(this.resImage, this.rectCrop);

  @override
  void paint(Canvas canvas, Size size) {
    if (resImage == null) {
      return;
    }
    final Rect rect = Offset.zero & size;
    final Size imageSize =
        Size(resImage.width.toDouble(), resImage.height.toDouble());
    FittedSizes sizes = applyBoxFit(BoxFit.fitHeight, imageSize, size);

    Rect inputSubRect = rectCrop;
    final Rect outputSubRect =
        Alignment.center.inscribe(sizes.destination, rect);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;
    canvas.drawRect(rect, paint);

    canvas.drawImageRect(resImage, inputSubRect, outputSubRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}