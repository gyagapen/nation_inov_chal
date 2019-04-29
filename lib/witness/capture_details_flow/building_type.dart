import 'package:flutter/material.dart';
import 'stepper.dart';
import 'dart:async';

import 'package:mausafe_v0/models/trigger_event.dart';

Future<Null> showBuildingTypeDialog(
    BuildContext context, TriggerEvent id, callback) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {


      return new AlertDialog(
        title: new Text('Sinister Details'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Please select your building type'),
            ],
          ),
          //child: new MyStepperPage(),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
                //callback(id);
              }),
          new FlatButton(
              child: new Text('Next'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      );
    },
  );
}
