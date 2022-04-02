import 'package:flutter/material.dart';
import 'package:gbdk_graphic_editor/widgets/tiles/meta_tile_display.dart';

import '../../meta_tile.dart';

class MetaTileCanvas extends StatefulWidget {
  final MetaTile metaTile;
  final Function onTap;
  final bool showGrid;
  final bool floodMode;
  final int metaTileIndex;
  final List<Color> colorSet;

  late final List<int> pattern;

  MetaTileCanvas(
      {required this.metaTile,
      required this.showGrid,
      required this.floodMode,
      required this.metaTileIndex,
      required this.colorSet,
      required this.onTap,
      Key? key})
      : super(key: key) {
    pattern = metaTile.getPattern();
  }

  @override
  State<MetaTileCanvas> createState() => _MetaTileCanvasState();
}

class _MetaTileCanvasState extends State<MetaTileCanvas> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          MouseRegion(
        cursor: SystemMouseCursors.precise,
        onEnter: (PointerEvent details) => setState(() => isHover = true),
        onExit: (PointerEvent details) => setState(() {
          isHover = false;
        }),
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            if (isHover && widget.floodMode == false) {
              draw(details, constraints);
            }
          },
          onTapDown: (TapDownDetails details) {
            if (isHover) {
              draw(details, constraints);
            }
          },
          child: MetaTileDisplay(
            metaTileIndex: widget.metaTileIndex,
            metaTile: widget.metaTile,
            showGrid: widget.showGrid,
            colorSet: widget.colorSet,
          ),
        ),
      ),
    );
  }

  draw(dynamic details, BoxConstraints constraints) {
    var localPosition = details.localPosition;
    final pixelSize = constraints.maxWidth / widget.metaTile.width;
    final rowIndex = (localPosition.dx / pixelSize).floor();
    final colIndex = (localPosition.dy / pixelSize).floor();

    if (widget.floodMode) {
      int targetColor =
          widget.metaTile.getPixel(rowIndex, colIndex, widget.metaTileIndex);
      flood(rowIndex, colIndex, targetColor);
    } else {
      widget.onTap(rowIndex, colIndex);
    }
  }

  flood(int rowIndex, int colIndex, int targetColor) {
    if (widget.metaTile.getPixel(rowIndex, colIndex, widget.metaTileIndex) ==
        targetColor) {
      widget.onTap(rowIndex, colIndex);
      if (inbound(rowIndex, colIndex - 1)) {
        flood(rowIndex, colIndex - 1, targetColor);
      }
      if (inbound(rowIndex, colIndex + 1)) {
        flood(rowIndex, colIndex + 1, targetColor);
      }
      if (inbound(rowIndex - 1, colIndex)) {
        flood(rowIndex - 1, colIndex, targetColor);
      }
      if (inbound(rowIndex + 1, colIndex)) {
        flood(rowIndex + 1, colIndex, targetColor);
      }
    }
  }

  inbound(int rowIndex, int colIndex) =>
      rowIndex >= 0 &&
      rowIndex < widget.metaTile.height &&
      colIndex >= 0 &&
      colIndex < widget.metaTile.width;
}