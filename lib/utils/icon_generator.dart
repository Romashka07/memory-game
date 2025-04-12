import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IconGenerator {
  static Future<void> generateIcons() async {
    final directory = Directory('assets/images/game');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final icons = [
      _buildHeart(),
      _buildStar(),
      _buildDiamond(),
      _buildCircle(),
      _buildSquare(),
      _buildTriangle(),
      _buildCrown(),
      _buildFlower(),
    ];

    for (var i = 0; i < icons.length; i++) {
      final widget = icons[i];
      final fileName = [
        'heart',
        'star',
        'diamond',
        'circle',
        'square',
        'triangle',
        'crown',
        'flower',
      ][i];

      await _saveWidgetAsPng(widget, '${directory.path}/$fileName.png');
    }
  }

  static Widget _buildHeart() {
    return CustomPaint(
      size: const Size(128, 128),
      painter: _HeartPainter(),
    );
  }

  static Widget _buildStar() {
    return CustomPaint(
      size: const Size(128, 128),
      painter: _StarPainter(),
    );
  }

  static Widget _buildDiamond() {
    return CustomPaint(
      size: const Size(128, 128),
      painter: _DiamondPainter(),
    );
  }

  static Widget _buildCircle() {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 8),
      ),
    );
  }

  static Widget _buildSquare() {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 8),
      ),
    );
  }

  static Widget _buildTriangle() {
    return CustomPaint(
      size: const Size(128, 128),
      painter: _TrianglePainter(),
    );
  }

  static Widget _buildCrown() {
    return CustomPaint(
      size: const Size(128, 128),
      painter: _CrownPainter(),
    );
  }

  static Widget _buildFlower() {
    return CustomPaint(
      size: const Size(128, 128),
      painter: _FlowerPainter(),
    );
  }

  static Future<void> _saveWidgetAsPng(Widget widget, String path) async {
    final repaintBoundary = RepaintBoundary(
      child: SizedBox(
        width: 128,
        height: 128,
        child: widget,
      ),
    );

    final context = ui.PipelineOwner();
    final renderObject = repaintBoundary.createRenderObject(context as BuildContext);
    final image = await renderObject.toImage(pixelRatio: 1);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final file = File(path);
    await file.writeAsBytes(buffer);
  }
}

class _HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height * 0.8)
      ..cubicTo(
        size.width * 0.8,
        size.height * 0.6,
        size.width,
        size.height * 0.4,
        size.width / 2,
        size.height * 0.2,
      )
      ..cubicTo(
        0,
        size.height * 0.4,
        size.width * 0.2,
        size.height * 0.6,
        size.width / 2,
        size.height * 0.8,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (var i = 0; i < 5; i++) {
      final angle = -pi / 2 + 2 * pi * i / 5;
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..lineTo(size.width * 0.4, size.height * 0.5)
      ..lineTo(size.width * 0.6, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FlowerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4;

    for (var i = 0; i < 6; i++) {
      final angle = pi * i / 3;
      canvas.drawCircle(
        Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        ),
        radius,
        paint,
      );
    }

    canvas.drawCircle(center, radius * 0.8, Paint()..color = Colors.yellow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 