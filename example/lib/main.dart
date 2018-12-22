import 'dart:ui';

import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter/material.dart';

import 'dart:math' as Math;
import 'package:vector_math/vector_math_64.dart' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SweetAlert',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SweetAlert'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    //Future.delayed(duration)
    //  animationController.animateTo(1.0,duration:new Duration(seconds: 1),curve: Curves.ease);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: new Container(
          width: double.infinity,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text("Basic usage"),
              new RaisedButton(
                onPressed: () {
                  SweetAlert.show(context, title: "Just show a message");
                },
                child: new Text("Try me"),
                color: SweetAlert.success,
                textColor: Colors.white,
              ),
              new Text("Title with subtitle"),
              new RaisedButton(
                onPressed: () {
                  SweetAlert.show(context,
                      title: "Just show a message",
                      subtitle: "Sweet alert is pretty");
                },
                child: new Text("Try me"),
                color: SweetAlert.success,
                textColor: Colors.white,
              ),
              new Text("A success message"),
              new RaisedButton(
                onPressed: () {
                  SweetAlert.show(context,
                      title: "Just show a message",
                      subtitle: "Sweet alert is pretty",
                      style: SweetAlertStyle.success);
                },
                child: new Text("Try me"),
                color: SweetAlert.success,
                textColor: Colors.white,
              ),
              new Text(
                  "A warning message,with a function action on \"Confirm\"-button"),
              new RaisedButton(
                onPressed: () {
                  SweetAlert.show(context,
                      title: "Just show a message",
                      subtitle: "Sweet alert is pretty",
                      style: SweetAlertStyle.confirm,
                      showCancelButton: true, onPress: (bool isConfirm) {
                    if (isConfirm) {
                      SweetAlert.show(context,style: SweetAlertStyle.success,title: "Success");

                      // return false to keep dialog
                      return false;
                    }
                  });
                },
                child: new Text("Try me"),
                color: SweetAlert.success,
                textColor: Colors.white,
              ),
              new Text("Do a job that may take some time"),
              new RaisedButton(
                onPressed: () {
                  SweetAlert.show(context,
                      subtitle: "Do you want to delete this message",
                      style: SweetAlertStyle.confirm,
                      showCancelButton: true, onPress: (bool isConfirm) {
                    if(isConfirm){
                      SweetAlert.show(context,subtitle: "Deleting...", style: SweetAlertStyle.loading);
                      new Future.delayed(new Duration(seconds: 2),(){
                        SweetAlert.show(context,subtitle: "Success!", style: SweetAlertStyle.success);
                      });
                    }else{
                      SweetAlert.show(context,subtitle: "Canceled!", style: SweetAlertStyle.error);
                    }
                    // return false to keep dialog
                    return false;
                  });
                },
                child: new Text("Try me"),
                color: SweetAlert.success,
                textColor: Colors.white,
              ),


              new Text("Do a job that may fail"),
              new RaisedButton(
                onPressed: () {
                  SweetAlert.show(context,
                      subtitle: "Do you want to delete this message",
                      style: SweetAlertStyle.confirm,
                      showCancelButton: true, onPress: (bool isConfirm) {
                        if (isConfirm) {
                        //Return false to keep dialog
                          if(isConfirm){
                            SweetAlert.show(context,subtitle: "Deleting...", style: SweetAlertStyle.loading);
                            new Future.delayed(new Duration(seconds: 2),(){
                              SweetAlert.show(context,subtitle: "Job fail!", style: SweetAlertStyle.error);
                            });
                          }else{
                            SweetAlert.show(context,subtitle: "Canceled!", style: SweetAlertStyle.error);
                          }
                          return false;
                        }

                      });
                },
                child: new Text("Try me"),
                color: SweetAlert.success,
                textColor: Colors.white,
              ),
            ],
          ),
        ));
  }
}

class MyPainter extends CustomPainter {
  Paint _paint = new Paint();

  double _r = 32.0;
  double factor = 0.96;

  double strokeStart;
  double strokeEnd;
  double total = 0;

  double _strokeStart;
  double _strokeEnd;

  MyPainter({this.strokeEnd, this.strokeStart}) {
    _paint.color = Color(0xff96d873);
    _paint.strokeCap = StrokeCap.round;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 4.0;

    Path path = new Path();
    path.addArc(new Rect.fromCircle(center: new Offset(_r, _r), radius: _r),
        math.radians(60.0 - 30.0), math.radians(-200.0));
    path.lineTo(24.0, 46.0);
    path.lineTo(49.0, 18.0);
    PathMetrics metrics;
    metrics = path.computeMetrics();
    for (PathMetric pathMetric in metrics) {
      total += pathMetric.length;
    }

    _strokeStart = strokeStart * total;
    _strokeEnd = strokeEnd * total;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double current = 0;
    Path path = new Path();
    path.addArc(new Rect.fromCircle(center: new Offset(_r, _r), radius: _r),
        math.radians(60.0 - 30.0), math.radians(-200.0));
    path.lineTo(24.0, 46.0);
    path.lineTo(49.0, 18.0);
    PathMetrics metrics = path.computeMetrics();
    for (PathMetric pathMetric in metrics) {
      canvas.drawPath(
          pathMetric.extractPath(_strokeStart, _strokeEnd - current), _paint);
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return strokeStart != oldDelegate.strokeStart ||
        strokeEnd != oldDelegate.strokeEnd;
  }
}
