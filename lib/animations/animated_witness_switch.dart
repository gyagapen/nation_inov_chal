import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../helpers/open_settings_menu.dart';

class AnimatedWitnessSwitch extends AnimatedWidget {
  AnimatedWitnessSwitch({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    var iconContainer = new AnimatedOpacity(
      opacity: animation.value > 40 ? 1.0 : 0.0,
      duration: new Duration(milliseconds: 500),
      child: new Icon(Icons.remove_red_eye),
    );

    return iconContainer;
  }
}
