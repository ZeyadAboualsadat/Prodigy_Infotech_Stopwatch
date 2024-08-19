import 'dart:math';
import 'package:flutter/material.dart';

class StopwatchPainter extends CustomPainter {
  final double progress; // Progress from 0.0 to 1.0
  final String timeText;

  StopwatchPainter(this.progress, this.timeText);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = min(size.width / 2, size.height / 2) - -30;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double sweepAngle = 2 * pi * progress;

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final Paint progressPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: timeText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    // Draw the progress arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius + 15),
      -pi / 2, // Start angle
      sweepAngle, // Sweep angle
      false,
      progressPaint,
    );

    // Draw the time inside the circle
    canvas.drawCircle(Offset(centerX, centerY), radius, backgroundPaint);
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
