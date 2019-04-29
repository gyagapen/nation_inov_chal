import 'package:flutter/material.dart';
import 'building_type.dart';
import 'dart:async';

import 'package:mausafe_v0/models/trigger_event.dart';

Future<Null> showSinisterTypeDialog(
    BuildContext context, TriggerEvent id, callback) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

    List<String> _sinisterTypes = ['A', 'B', 'AB', '0'];
    String _selectedSinisterType = "A";

    var sinisterTypeDropDown = DropdownButton(
      items: _sinisterTypes.map((String val) {
        return new DropdownMenuItem<String>(
          value: val,
          child: new Text(val),
        );
      }).toList(),
      value: _selectedSinisterType,
      onChanged: (newValue) {
          _selectedSinisterType = newValue;
      },
    );

      return new AlertDialog(
        title: new Text('Sinister Details'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Please select the sinister type'),
              sinisterTypeDropDown,
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
                showBuildingTypeDialog(context, id, callback);
              }),
        ],
      );
    },
  );
}
