import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingAnimation extends StatefulWidget {
  _AnimationState createState() => _AnimationState();
}


class _Animation extends AnimatedWidget {

  _Animation({Key key, Animation<double> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}


// #docregion print-state
class _AnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
    // #enddocregion print-state
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
    // #docregion print-state
      ..addStatusListener((state) => print('$state'));
      controller.forward();
  }
  // #enddocregion print-state

  @override
  Widget build(BuildContext context) => _Animation(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
// #docregion print-state
}