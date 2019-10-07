import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart' as prefix0;

class ModalAnimation extends ModalRoute<void> {
  Function _disposeFunction;

  ModalAnimation(void connectionClear()) {
    _disposeFunction = connectionClear;
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Fluttertoast.showToast(
              msg: "파티 찾기를 취소했습니다.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '앱을 백그라운드로 돌리고 다른 작업을 하셔도 됩니다.',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Text(
                '파티를 찾으면 푸쉬알람을 보내드릴게요.',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Container(
                margin: EdgeInsets.only(top: 40, bottom: 40),
                child: SpinKitPouringHourglass(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
              FlatButton(
                color: Colors.red,
                onPressed: () =>
                {
                  Fluttertoast.showToast(
                      msg: "파티 찾기를 취소했습니다.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0),
                  Navigator.pop(context),
                },
                child: Text('그만 찾기'),
              )
            ],
          ),
        ));
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    print('dispose');
    Fluttertoast.cancel();
    _disposeFunction();
    super.dispose();
  }
}
