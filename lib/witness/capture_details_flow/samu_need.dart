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



      return new AlertDialog(
        title: new Text('Is SAMU needed ?'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new SamuDialogContent(witnessDetails: witnessDetails,)
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
                Navigator.pop(context);
                WitnessFlowManager.showWitnessNextStep(SAMU_DIALOG_ID, witnessDetails, context, id, callback);
              }),
        ],
      );
    },
  );
}

class SamuDialogContent extends StatefulWidget {
  SamuDialogContent({
    Key key,
    this.witnessDetails,
  }): super(key: key);

  WitnessDetails witnessDetails;

  @override
  _SamuDialogContentState createState() => new _SamuDialogContentState();
}

class _SamuDialogContentState extends State<SamuDialogContent> {
  
  bool _radioValue = false;

  void _handleRadioValueChange(bool value) {
      setState(() {
        _radioValue = value;
        widget.witnessDetails.isSAMUNeeded = _radioValue;
      });
  }

  @override
  void initState(){
    super.initState();
    widget.witnessDetails.isSAMUNeeded = _radioValue;
  }


  @override
  Widget build(BuildContext context) {
   return new Row(
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
              );
  }
}

