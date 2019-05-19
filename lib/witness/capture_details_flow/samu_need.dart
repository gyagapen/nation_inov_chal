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
        title: new Text('Is SAMU needed ?', style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new SamuDialogContent(witnessDetails: witnessDetails,),
              new Container(
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: new Text('Is a person trapped?', style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
              new PersonTrappedDialogContent(witnessDetails: witnessDetails,)
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Back'),
              onPressed: () {
                Navigator.pop(context);
                WitnessFlowManager.showWitnessPreviousStep(SAMU_DIALOG_ID, witnessDetails, context, id, callback);
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


class PersonTrappedDialogContent extends StatefulWidget {
  PersonTrappedDialogContent({
    Key key,
    this.witnessDetails,
  }): super(key: key);

  WitnessDetails witnessDetails;

  @override
  _PersonTrappedDialogContentState createState() => new _PersonTrappedDialogContentState();
}

class _PersonTrappedDialogContentState extends State<PersonTrappedDialogContent> {
  
  bool _radioValue = false;

  void _handleRadioValueChange(bool value) {
      setState(() {
        _radioValue = value;
        widget.witnessDetails.isAPersonTrapped = _radioValue;
      });
  }

  @override
  void initState(){
    super.initState();
    widget.witnessDetails.isAPersonTrapped = _radioValue;
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


