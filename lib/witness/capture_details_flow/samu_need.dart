import 'package:flutter/material.dart';
import 'flow_manager.dart';
import 'dart:async';
import '../../models/witness_details.dart';

import 'package:mausafe_v0/models/trigger_event.dart';

 const String SAMU_DIALOG_ID = "samu_type_dialog";

Future<Null> showSamuDialog(WitnessDetails witnessDetails,
    BuildContext context, TriggerEvent id, callback) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

      bool _radioValue = false;

        void _handleRadioValueChange(bool value) {
        //setState(() {});
        _radioValue = value;}

      return new AlertDialog(
        title: new Text('SAMU'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('SAMU is needed ?'),
              new Row(
                children: <Widget>[
                  new Text('Yes'),
                  new Radio(
                    value: true,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  new Text('No'),
                  new Radio(
                    value: false,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  )
                ],
              )
            ],
          ),
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
                witnessDetails.isSAMUNeeded = _radioValue;
                Navigator.pop(context);
                WitnessFlowManager.showWitnessNextStep(SAMU_DIALOG_ID, witnessDetails, context, id, callback);
              }),
        ],
      );
    },
  );
}
