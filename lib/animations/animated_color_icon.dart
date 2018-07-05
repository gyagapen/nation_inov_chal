import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedColorIcon extends AnimatedWidget {
  AnimatedColorIcon(
      {Key key,
      Animation<double> animation,
      this.iconImage,
      this.color1,
      this.color2})
      : super(key: key, listenable: animation);

  final AssetImage iconImage;
  final Color color1;
  final Color color2;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    var animatedIcon = new AnimatedOpacity(
      opacity: 1.0,
      duration: new Duration(milliseconds: 500),
      child: new ImageIcon(iconImage, color: animation.value > 50 ? color1 : color2,),
    );
    return animatedIcon;
  }
}
