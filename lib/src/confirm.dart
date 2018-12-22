import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'package:vector_math/vector_math_64.dart' as math;
import 'dart:ui';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class ConfirmView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ConfirmViewState();
  }
}

class ConfirmViewState extends State<ConfirmView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  Animation<Color> animation;

  @override
  void initState() {
    int factor = 50;
    animationController = new AnimationController(vsync: this);
    animation =
        new ColorTween(begin: new Color(0xffF7D58B), end: new Color(0xffF2A665))
            .animate(animationController);

    //delay
    new Future.delayed(new Duration(milliseconds: 200)).then((_) {
      forward();
    });

    super.initState();
  }

  void forward() {
    animationController
        .animateTo(1.0,
            duration: new Duration(milliseconds: 600), curve: Curves.ease)
        .then((_) {
      backward();
    });
  }

  void backward() {
    animationController
        .animateTo(0.0,
            duration: new Duration(milliseconds: 600), curve: Curves.ease)
        .then((_) {
      forward();
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
        animation: animationController,
        builder: (c, w) {
          return new CustomPaint(
            painter: new _CustomPainter(color: animation.value),
          );
        });
  }
}

class _CustomPainter extends CustomPainter {
  Paint _paint = new Paint();

  Color color;

  double _r = 32.0;
  double factor = 0.96;

  _CustomPainter({this.color}) {
    _paint.strokeCap = StrokeCap.round;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 4.0;

    _paint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();
    path.addArc(new Rect.fromCircle(center: new Offset(_r, _r), radius: _r),
        0.0, math.radians(360.0));

    double factor = 64 / 1.5;
    path.moveTo(_r, 15.0);
    path.lineTo(_r, factor);

    path.moveTo(_r, factor + 10.0);
    path.addArc(
        new Rect.fromCircle(center: new Offset(_r, factor + 10.0), radius: 1.0),
        0.0,
        math.radians(360.0));

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
