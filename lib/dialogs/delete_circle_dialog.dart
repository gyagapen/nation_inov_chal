import 'package:flutter/material.dart';
import 'dart:async';

Future<Null> showDeleteCircleDialog(
    BuildContext context, String id, callback) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Deletion confirmation'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Do you really want to delete this emergency contact?'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                callback(id);
              }),
          new FlatButton(
              child: new Text('No'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      );
    },
  );
}
