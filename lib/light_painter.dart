import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

class LightPainter extends CustomPainter {
  final double value;

  //Construction
  final double cableWidth = 10;
  final double cableLength = 100;
  final double lampUpperWidth = 180;
  final double lampLowerWidth = 280;
  final double lampHeight = 150;

  LightPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    _drawLamp(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawLamp(Canvas canvas, Size size) {
    final double startingPointX = size.width * 0.2;

    Offset start = Offset(startingPointX, 0);

    Path constructionPath = Path();
    Offset polygonCenter = Offset(startingPointX + cableWidth * 0.5, cableLength + lampHeight * 0.5);

    constructionPath.addRect(
      Rect.fromLTWH(start.dx, start.dy, cableWidth, cableLength),
    );

    _drawLight(canvas, polygonCenter, size);

    constructionPath.addPolygon(
      [
        polygonCenter.translate(0, -lampHeight * 0.5),
        polygonCenter.translate(lampUpperWidth * 0.5, -lampHeight * 0.5),
        polygonCenter.translate(lampLowerWidth * 0.5, lampHeight * 0.5),
        polygonCenter.translate(-lampLowerWidth * 0.5, lampHeight * 0.5),
        polygonCenter.translate(-lampUpperWidth * 0.5, -lampHeight * 0.5),
      ],
      true,
    );

    canvas.drawPath(
      constructionPath,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill,
    );

    //Bulb
    const double bulbWidth = 80;
    const double bulbHeight = bulbWidth * 0.7;

    Offset bulbStart = Offset(startingPointX + cableWidth * 0.5, cableLength + lampHeight);

    Path bulbPath = Path()..moveTo(bulbStart.dx, bulbStart.dy);

    Offset upperRight = bulbStart.translate(bulbWidth * 0.5, 0);
    Offset upperLeft = bulbStart.translate(-bulbWidth * 0.5, 0);

    bulbPath.lineTo(upperRight.dx, upperRight.dy);
    bulbPath.cubicTo(upperRight.dx, upperRight.dy + bulbHeight, upperLeft.dx, upperLeft.dy + bulbHeight, upperLeft.dx, upperLeft.dy);
    bulbPath.close();

    canvas.drawPath(bulbPath, Paint()..color = Colors.yellow);
  }

  void _drawLight(Canvas canvas, Offset center, Size size) {
    Path lightPath = Path();

    lightPath.addPolygon(
      [
        center.translate(0, -lampHeight * 0.5), // upper center point
        center.translate(lampUpperWidth * 0.5, -lampHeight * 0.5), //upperRight
        center.translate(lampLowerWidth, lampHeight * 3.4), //lowerRight
        center.translate(-lampLowerWidth, lampHeight * 3.4), //lowerLeft
        center.translate(-lampUpperWidth * 0.5, -lampHeight * 0.5), //upperLeft
      ],
      true,
    );

    canvas.drawPath(
      lightPath,
      Paint()
        ..color = Colors.yellow
        ..shader = LinearGradient(
          colors: [
            Colors.yellow.withOpacity((value - 0.2).clamp(0, 1.0)),
            Colors.yellow.withOpacity((value - 0.7).clamp(0, 1.0)),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Offset.zero & size),
    );
  }
}
