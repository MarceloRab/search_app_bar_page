import 'package:flutter/material.dart';

class AppBarPainter extends CustomPainter {
  final Offset? center;
  final double? radius, containerHeight;
  final BuildContext? context;

  final Color? color;

  const AppBarPainter({
    this.context,
    this.containerHeight,
    this.center,
    this.radius,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePainter = Paint()..color = color!;

    // Clip strictly to the painter's available width and the intended container height.
    // This avoids leaking the ripple outside dialogs/alerts with constrained width.
    final clipWidth = size.width;
    final clipHeight = containerHeight ?? size.height;
    canvas.clipRect(Rect.fromLTWH(0, 0, clipWidth, clipHeight));

    canvas.drawCircle(center!, radius!, circlePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
