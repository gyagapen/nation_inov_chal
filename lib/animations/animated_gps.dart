import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../helpers/open_settings_menu.dart';

class AnimatedGPSStatus extends AnimatedWidget {
  AnimatedGPSStatus({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    var gpsContainer = new AnimatedOpacity(
      opacity: animation.value > 40 ? 1.0 : 0.0,
      duration: new Duration(milliseconds: 500),
      child: new Container(
        padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        //decoration: new BoxDecoration(color: Colors.black45),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            new Container(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
              child: new Icon(Icons.gps_off, color: Colors.red),
            ),
            new Container(
              child: new Text(
                "GPS is Off. Tap here to activate",
                style: new TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );

    var gpsGestureContainer = new GestureDetector(
      onTap: () {
        if (animation.value != 0.0) {
          OpenSettings.GPSMenu();
        }
      },
      child: gpsContainer,
    );

    return gpsGestureContainer;
  }
}
