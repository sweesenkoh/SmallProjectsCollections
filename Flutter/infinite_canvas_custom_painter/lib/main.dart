import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InfiniteCanvasPage(),
    );
  }
}

enum CanvasState { pan, draw }

class InfiniteCanvasPage extends StatefulWidget {
  @override
  _InfiniteCanvasPageState createState() => _InfiniteCanvasPageState();
}

class _InfiniteCanvasPageState extends State<InfiniteCanvasPage> {
  List<Offset> points = [];
  CanvasState canvasState = CanvasState.draw;
  Offset offset = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text(canvasState == CanvasState.draw ? "Draw" : "Pan"),
        backgroundColor:
            canvasState == CanvasState.draw ? Colors.red : Colors.blue,
        onPressed: () {
          this.setState(() {
            canvasState = canvasState == CanvasState.draw
                ? CanvasState.pan
                : CanvasState.draw;
          });
        },
      ),
      body: GestureDetector(
        onPanDown: (details) {
          this.setState(() {
            if (canvasState == CanvasState.draw) {
              points.add(details.localPosition - offset);
            }
          });
        },
        onPanUpdate: (details) {
          this.setState(() {
            if (canvasState == CanvasState.pan) {
              offset += details.delta;
            } else {
              points.add(details.localPosition - offset);
            }
          });
        },
        onPanEnd: (details) {
          this.setState(() {
            if (canvasState == CanvasState.draw) {
              points.add(null);
            }
          });
        },
        child: SizedBox.expand(
          child: ClipRRect(
            child: CustomPaint(
              painter: CanvasCustomPainter(points: points, offset: offset),
            ),
          ),
        ),
      ),
    );
  }
}

class CanvasCustomPainter extends CustomPainter {
  List<Offset> points;
  Offset offset;

  CanvasCustomPainter({@required this.points, this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    //define canvas background color
    Paint background = Paint()..color = Colors.white;

    //define canvas size
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    //define the paint properties to be used for drawing
    Paint drawingPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = Colors.black
      ..strokeWidth = 1.5;

    //a single line is defined as a series of points followed by a null at the end
    for (int x = 0; x < points.length - 1; x++) {
      //drawing line between the points to form a continuous line
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(
            points[x] + offset, points[x + 1] + offset, drawingPaint);
      }
      //if next point is null, means the line ends here
      else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[x] + offset], drawingPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CanvasCustomPainter oldDelegate) {
    return true;
  }
}
