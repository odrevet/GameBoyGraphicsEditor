import 'package:flutter/material.dart';

class DotMatrix extends StatefulWidget {
  final List<Color> pixels;
  final bool showGrid;

  const DotMatrix({Key? key, required this.pixels, this.showGrid = false})
      : super(key: key);

  @override
  _DotMatrixState createState() => _DotMatrixState();
}

class _DotMatrixState extends State<DotMatrix> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return CustomPaint(
            size: Size(
              constraints.maxWidth,
              constraints.maxHeight,
            ),
            painter: DotMatrixPainter(
                pixels: widget.pixels,
                constraints: constraints,
                showGrid: widget.showGrid),
          );
        },
      ),
    );
  }
}

class DotMatrixPainter extends CustomPainter {
  final Paint painter = Paint();
  final int crossAxisCount = 8;
  late double pixelSize;
  final List<Color> pixels;
  final BoxConstraints constraints;
  final bool showGrid;

  DotMatrixPainter(
      {required this.pixels, required this.constraints, this.showGrid = false});

  @override
  void paint(Canvas canvas, Size size) {
    pixelSize = constraints.maxWidth / 8;
    pixels.asMap().forEach((index, pixel) {
      painter.color = pixel;
      canvas.drawRect(
          Rect.fromLTWH(
            (index % crossAxisCount).floor().toDouble() * pixelSize,
            (index / crossAxisCount).floor().toDouble() * pixelSize,
            pixelSize,
            pixelSize,
          ),
          painter);
    });

    if (showGrid) {
      painter.color = Colors.blueGrey;
      for (int index = 1; index < crossAxisCount; index++) {
        canvas.drawLine(
            Offset((index % crossAxisCount).floor().toDouble() * pixelSize, 0),
            Offset((index % crossAxisCount).floor().toDouble() * pixelSize,
                size.height),
            painter);

        canvas.drawLine(
            Offset(0, (index % crossAxisCount).floor().toDouble() * pixelSize),
            Offset(size.width,
                (index % crossAxisCount).floor().toDouble() * pixelSize),
            painter);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
