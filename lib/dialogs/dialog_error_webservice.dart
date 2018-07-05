import 'package:flutter/material.dart';
import '../helpers/open_settings_menu.dart';
import 'dart:async';

Future<Null> showDataConnectionError(context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Cannot connect...'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Cannot contact MauSafe servers. Kindly ensure that you are connected to internet'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Turn On Wifi/3G'),
              onPressed: () {
                OpenSettings.WirelessMenu();
                Navigator.of(context).pop();
              }),
          new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      );
    },
  );
}
