import 'package:flutter/material.dart';
import 'flow_manager.dart';
import 'dart:async';
import '../../models/witness_details.dart';
import '../../helpers/utilities.dart';

import 'package:mausafe_v0/models/trigger_event.dart';

 const String FLOOR_NUMBER_DIALOG_ID = "floor_number_dialog";

Future<Null> showFloorNumberDialog(WitnessDetails witnessDetails,
    BuildContext context, TriggerEvent id, callback) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

      return new AlertDialog(
        title: new Text('Number or floor(s)?'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new FloorNumberContent(witnessDetails: witnessDetails,)
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
                  WitnessFlowManager.showWitnessNextStep(FLOOR_NUMBER_DIALOG_ID,
                  witnessDetails, context, id, callback);
              }),
        ],
      );
    },
  );
}

class FloorNumberContent extends StatefulWidget {
  FloorNumberContent({
    Key key,
    this.witnessDetails,
  }): super(key: key);

  WitnessDetails witnessDetails;

  @override
  _FloorNumberContentState createState() => new _FloorNumberContentState();
}

class _FloorNumberContentState extends State<FloorNumberContent> {

  String _radioValue = "1-3";

  void _handleRadioValueChange(String value) {
      setState(() {
        _radioValue = value;
        widget.witnessDetails.noOfFloors = _radioValue;
      });
  }

  @override
  void initState(){
    super.initState();
    widget.witnessDetails.noOfFloors = _radioValue;
  }


  @override
  Widget build(BuildContext context) {
   return new Row(
                children: <Widget>[
                  new Text('1-3'),
                  new Radio(
                    value: "1-3",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  new Text('4-7'),
                  new Radio(
                    value: "4-7",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  new Text('8+'),
                  new Radio(
                    value: "8+",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  )
                ],
              );
  }

}
