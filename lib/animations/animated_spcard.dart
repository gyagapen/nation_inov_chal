import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../models/service_provider.dart';

class AnimatedSpCard extends AnimatedWidget {
  AnimatedSpCard(
      {Key key,
      Animation<double> animation,
      this.serviceProvider,
      this.header
      })
      : super(key: key, listenable: animation);

  final ServiceProvider serviceProvider;
  final Container header;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    //functions
    double getOpacity() {
      double opacityValue = 1.0;

      if (serviceProvider.status.value == 0) {
        opacityValue = animation.value > 40 ? 1.0 : 0.0;
      }

      return opacityValue;
    }

    Color getAnimatedColor() {
      Color currentColor = Colors.white;

      switch (serviceProvider.status.value) {
        case 0:
          currentColor = animation.value > 40 ? Colors.orange : Colors.white;
          break;
        case 1:
          currentColor = Colors.lightGreen;
          break;
      }

      return currentColor;
    }

    String getETAText()
    {
      String eTAText = "";

      if(serviceProvider.status.value == 1)
      {
        eTAText = "ETA: ${serviceProvider.status.estTimeArrival}min";
      }

      return eTAText;
    }

    //UI components
    var animatedText = new AnimatedOpacity(
      opacity: getOpacity(),
      duration: new Duration(milliseconds: 500),
      child: new Container(
        padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new Container(
          child: new Text(
            serviceProvider.status.getStatusText().toUpperCase(),
            style: new TextStyle(color: Colors.black, fontSize: 15.0),
          ),
        ),
      ),
    );

    var spContainer = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        new Container(
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
          child: animatedText,
        ),
        new Container(
          padding: new EdgeInsets.fromLTRB(0.0, 25.0, 5.0, 0.0),
          child: new Text(getETAText(), style: new TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),),
        )
      ],
    );

    var spCard = new Card(
        child: new Container(
          width: 300.0,
          height: 130.0,
          child: new Column(children: [
            header,
            spContainer,
          ]),
        ));

    var spCardAnimated = new AnimatedContainer(
      margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 20.0),
      duration: new Duration(milliseconds: 500),
      color: getAnimatedColor(),
      child: spCard,
    );

    return spCardAnimated;
  }
}
