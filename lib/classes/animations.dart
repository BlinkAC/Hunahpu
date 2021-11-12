import 'package:flutter/cupertino.dart';

class AnimationPage extends PageRouteBuilder {
  final Widget widget;
  AnimationPage({required this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.easeIn);
              return ScaleTransition(
                  scale: animation, alignment: Alignment.center, child: child);
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
