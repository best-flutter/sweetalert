import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'dart:math' as Math;
import 'package:vector_math/vector_math_64.dart' as math;
import 'dart:ui';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class CancelView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CancelViewState();
  }
}

class CancelViewState extends State<CancelView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    int factor = 50;
    animationController = new AnimationController(vsync: this);

    sequenceAnimation = new SequenceAnimationBuilder()
        .addAnimatable(
            animatable: new Tween(begin: 90.0, end: 0.0),
            from: new Duration(milliseconds: 0),
            to: new Duration(milliseconds: 300),
            tag: "rotation")
        .addAnimatable(
            animatable: new Tween(begin: 0.3, end: 1.0),
            from: new Duration(milliseconds: 600),
            to: new Duration(milliseconds: 900),
            tag: "fade",
            curve: Curves.bounceOut)
        .addAnimatable(
            animatable: new Tween(begin: 32.0 / 5.0, end: 32.0 / 2.0),
            from: new Duration(milliseconds: 600),
            to: new Duration(milliseconds: 900),
            tag: "fact",
            curve: Curves.bounceOut)
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
        .then((_) {});
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  /**
   * new CustomPaint(
      painter: new SuccessPainter(color: SweetAlert.danger),
      )
   */
  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
        animation: animationController,
        builder: (c, w) {
          return new Transform(
            transform: Matrix4.rotationX(
                math.radians(sequenceAnimation['rotation'].value)),
            origin: new Offset(0.0, 32.0),
            child: new CustomPaint(
              painter: new _CustomPainter(
                  color: SweetAlert.danger,
                  fade: sequenceAnimation['fade'].value,
                  factor: sequenceAnimation['fact'].value),
            ),
          );
        });
  }
}

class _CustomPainter extends CustomPainter {
  Paint _paint = new Paint();

  Color color;

  double _r = 32.0;
  final double fade;
  final double factor;

  _CustomPainter({this.color, this.fade, this.factor}) {
    _paint.strokeCap = StrokeCap.round;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 4.0;
    _paint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();
    _paint.color = color;

    path.addArc(new Rect.fromCircle(center: new Offset(_r, _r), radius: _r),
        0.0, math.radians(360.0));
    canvas.drawPath(path, _paint);

    path = new Path();
    //fade
    _paint.color =
        new Color(color.value & 0x00FFFFFF + ((0xff * fade).toInt() << 24));

    path.moveTo(_r - factor, _r - factor);
    path.lineTo(_r + factor, _r + factor);

    path.moveTo(_r + factor, _r - factor);
    path.lineTo(_r - factor, _r + factor);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) {
    return color != oldDelegate.color || fade != oldDelegate.fade;
  }
}
