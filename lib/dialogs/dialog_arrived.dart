import 'package:flutter/material.dart';
import 'dart:async';

Future<Null> showArrivedDialog(context) async {
  List<Widget> flatButtons = new List<Widget>();

  flatButtons.add(FlatButton(
      child: new Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }));

  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('You are now safe !'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text("Request help has arrived, you are now safe!"),
            ],
          ),
        ),
        actions: flatButtons,
      );
    },
  );
}
