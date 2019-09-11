import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClickedMatchButtonAnimation extends StatefulWidget {
  _MatchingButtonAnimationState createState() => _MatchingButtonAnimationState();
}


class ClickedMatchButton extends AnimatedWidget {

  ClickedMatchButton({Key key, Animation<double> animation}) : super(key: key, listenable: animation);

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
class _MatchingButtonAnimationState extends State<ClickedMatchButtonAnimation> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) => ClickedMatchButton(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
// #docregion print-state
}