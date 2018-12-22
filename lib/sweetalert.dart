library sweetalert;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sweetalert/src/cancel.dart';
import 'package:sweetalert/src/confirm.dart';
import 'package:sweetalert/src/success.dart';


/// Return false to keey dialog showing
typedef bool SweetAlertOnPress(bool isConfirm);

enum SweetAlertStyle { success, error, confirm, loading }

class SweetAlertOptions {
  final String title;
  final String subtitle;

  final SweetAlertOnPress onPress;

  /// if null,
  /// default value is `SweetAlert.success` when `showCancelButton`=false
  /// and `SweetAlert.danger` when `showCancelButton` = true
  final Color confirmButtonColor;

  /// if null,default value is `SweetAlert.cancel`
  final Color cancelButtonColor;

  /// if null,default value is `SweetAlert.successText` when `showCancelButton`=false
  ///  and `SweetAlert.dangerText` when `showCancelButton` = true
  final String confirmButtonText;

  /// if null,default value is `SweetAlert.cancelText`
  final String cancelButtonText;

  /// If set to true, two buttons will be displayed.
  final bool showCancelButton;


  final SweetAlertStyle style;

  SweetAlertOptions(
      {this.showCancelButton: false,
      this.title,
      this.subtitle,
      this.onPress,
      this.cancelButtonColor,
      this.cancelButtonText,
      this.confirmButtonColor,
      this.confirmButtonText,
      this.style});
}

class SweetAlertDialog extends StatefulWidget {
  /// animation curve when showing,if null,default value is `SweetAlert.showCurve`
  final Curve curve;

  final SweetAlertOptions options;

  SweetAlertDialog({
    this.options,
    this.curve,
  }) : assert(options != null);

  @override
  State<StatefulWidget> createState() {
    return new SweetAlertDialogState();
  }
}

class SweetAlertDialogState extends State<SweetAlertDialog>
    with SingleTickerProviderStateMixin, SweetAlert {
  AnimationController controller;

  Animation tween;

  SweetAlertOptions _options;

  @override
  void initState() {
    _options = widget.options;
    controller = new AnimationController(vsync: this);
    tween = new Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.animateTo(1.0,
        duration: new Duration(milliseconds: 300),
        curve: widget.curve ?? SweetAlert.showCurve);

    SweetAlert._state = this;
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    SweetAlert._state = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(SweetAlertDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void confirm() {
    if (_options.onPress != null && _options.onPress(true) == false)
      return;
    Navigator.pop(context);
  }



  void cancel() {
    if (_options.onPress != null && _options.onPress(false) == false)
      return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listOfChildren = [];

    switch (_options.style) {
      case SweetAlertStyle.success:
        listOfChildren.add(new SizedBox(
          width: 64.0,
          height: 64.0,
          child: new SuccessView(),
        ));
        break;
      case SweetAlertStyle.confirm:
        listOfChildren.add(new SizedBox(
          width: 64.0,
          height: 64.0,
          child: new ConfirmView(),
        ));
        break;
      case SweetAlertStyle.error:
        listOfChildren.add(new SizedBox(
          width: 64.0,
          height: 64.0,
          child: new CancelView(),
        ));
        break;
      case SweetAlertStyle.loading:
        listOfChildren.add(new SizedBox(
          width: 64.0,
          height: 64.0,
          child: new Center(
            child: new CircularProgressIndicator(),
          ),
        ));
        break;
    }

    if (_options.title != null) {
      listOfChildren.add(new Text(
        _options.title,
        style: new TextStyle(fontSize: 25.0, color: new Color(0xff575757)),
      ));
    }

    if (_options.subtitle != null) {
      listOfChildren.add(new Padding(
        padding: new EdgeInsets.only(top: 10.0),
        child: new Text(
          _options.subtitle,
          style: new TextStyle(fontSize: 16.0, color: new Color(0xff797979)),
        ),
      ));
    }

    //we do not render buttons when style=loading
    if (_options.style != SweetAlertStyle.loading) {
      if (_options.showCancelButton) {
        listOfChildren.add(new Padding(
          padding: new EdgeInsets.only(top: 10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                onPressed: cancel,
                color: _options.cancelButtonColor ?? SweetAlert.cancel,
                child: new Text(
                  _options.cancelButtonText ?? SweetAlert.cancelText,
                  style: new TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              new SizedBox(
                width: 10.0,
              ),
              new RaisedButton(
                onPressed: confirm,
                color: _options.confirmButtonColor ?? SweetAlert.danger,
                child: new Text(
                  _options.confirmButtonText ?? SweetAlert.confirmText,
                  style: new TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ));
      } else {
        listOfChildren.add(new Padding(
          padding: new EdgeInsets.only(top: 10.0),
          child: new RaisedButton(
            onPressed: confirm,
            color: _options.confirmButtonColor ?? SweetAlert.success,
            child: new Text(
              _options.confirmButtonText ?? SweetAlert.successText,
              style: new TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ));
      }
    }

    return new Center(
        child: new AnimatedBuilder(
            animation: controller,
            builder: (c, w) {
              return new ScaleTransition(
                scale: tween,
                child: new ClipRRect(
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                  child: new Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: new Padding(
                        padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: listOfChildren,
                        ),
                      )),
                ),
              );
            }));
  }

  void update(SweetAlertOptions options) {
    setState(() {
      _options = options;
    });
  }
}

abstract class SweetAlert {
  static Color success = new Color(0xffAEDEF4);
  static Color danger = new Color(0xffDD6B55);
  static Color cancel = new Color(0xffD0D0D0);

  static String successText = "OK";
  static String confirmText = "Confirm";
  static String cancelText = "Cancel";

  static Curve showCurve = Curves.bounceOut;

  static SweetAlertDialogState _state;

  static void show(BuildContext context,
      {Curve curve,
      String title,
      String subtitle,
      bool showCancelButton: false,
      SweetAlertOnPress onPress,
      Color cancelButtonColor,
      Color confirmButtonColor,
      String cancelButtonText,
      String confirmButtonText,
      SweetAlertStyle style}) {
    SweetAlertOptions options =  new SweetAlertOptions(
        showCancelButton: showCancelButton,
        title: title,
        subtitle: subtitle,
        style: style,
        onPress: onPress,
        confirmButtonColor: confirmButtonColor,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        cancelButtonColor: confirmButtonColor);
    if(_state!=null){
      _state.update(options);
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new Container(
              color: Colors.transparent,
              child: new Padding(
                padding: new EdgeInsets.all(40.0),
                child: new Scaffold(
                  backgroundColor: Colors.transparent,
                  body: new SweetAlertDialog(
                      curve: curve,
                      options:options
                  ),
                ),
              ),
            );
          });
    }

  }
}
