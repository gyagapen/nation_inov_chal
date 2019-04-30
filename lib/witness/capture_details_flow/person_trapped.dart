import 'package:flutter/material.dart';
import 'flow_manager.dart';
import 'dart:async';
import '../../models/witness_details.dart';

import 'package:mausafe_v0/models/trigger_event.dart';

 const String PERSON_TRAPPED_DIALOG_ID = "person_trapped_dialog";

Future<Null> showPersonTrappedDialog(WitnessDetails witnessDetails,
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
        title: new Text('Person Trapped'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Is there someone trapped ?'),
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
                witnessDetails.isAPersonTrapped = _radioValue;
                Navigator.pop(context);
                WitnessFlowManager.showWitnessNextStep(PERSON_TRAPPED_DIALOG_ID, witnessDetails, context, id, callback);
              }),
        ],
      );
    },
  );
}
