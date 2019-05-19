import 'package:flutter/material.dart';
import 'flow_manager.dart';
import 'dart:async';
import '../../models/witness_details.dart';

import 'package:mausafe_v0/models/trigger_event.dart';

 const String SINISTER_TYPE_DIALOG_ID = "sinister_type_dialog";

Future<Null> showSinisterTypeDialog(WitnessDetails witnessDetails,
    BuildContext context, TriggerEvent id, callback) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {


    
      return new AlertDialog(
        title: new Text('Sinister Type?'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new SinisterDialogContent(witnessDetails: witnessDetails,),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
                WitnessFlowManager.showWitnessPreviousStep(SINISTER_TYPE_DIALOG_ID, witnessDetails, context, id, callback);
              }),
          new FlatButton(
              child: new Text('Next'),
              onPressed: () {
                Navigator.pop(context);
                WitnessFlowManager.showWitnessNextStep(SINISTER_TYPE_DIALOG_ID, witnessDetails, context, id, callback);
              }),
        ],
      );
    },
  );
}


class SinisterDialogContent extends StatefulWidget {
  SinisterDialogContent({
    Key key,
    this.witnessDetails,
  }): super(key: key);

  WitnessDetails witnessDetails;

  @override
  _SinisterDialogContentState createState() => new _SinisterDialogContentState();
}

class _SinisterDialogContentState extends State<SinisterDialogContent> {
  
  String _selectedSinisterType = "Building";

  double iconWidth = 30.0;
  double iconHeight = 30.0;

  @override
  void initState(){
    super.initState();
    widget.witnessDetails.impactType = _selectedSinisterType;
  }

  void _handleRadioValueChange(String value) {
      setState(() {
        _selectedSinisterType = value;
        widget.witnessDetails.impactType = _selectedSinisterType;
      });
  }


  @override
  Widget build(BuildContext context) {

     return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset("images/witness/Building_fire.png", height: iconHeight, width: iconWidth,),
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 0.0),
                  child: new Text("Building"),
                ),
                new Radio(
                    value: "Building",
                    groupValue: _selectedSinisterType,
                    onChanged: _handleRadioValueChange,
                  )
              ],
            ),
             new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset("images/witness/forest_fire.png", height: iconHeight, width: iconWidth,),
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 0.0),
                  child: new Text("Field"),
                ),
                new Radio(
                    value: "Field",
                    groupValue: _selectedSinisterType,
                    onChanged: _handleRadioValueChange,
                  )
              ],
            ),
             
          ],
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
               new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset("images/witness/car_fire.png", height: iconHeight, width: iconWidth,),
                  new Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 0.0),
                    child: new Text("Vehicle"),
                  ),
                  new Radio(
                      value: "Vehicle",
                      groupValue: _selectedSinisterType,
                      onChanged: _handleRadioValueChange,
                    )
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset("images/witness/Residential.png", height: iconHeight, width: iconWidth,),
                  new Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: new Text("Rubbish"),
                  ),
                  new Radio(
                      value: "Rubbish",
                      groupValue: _selectedSinisterType,
                      onChanged: _handleRadioValueChange,
                    )
                ],
              )
          ]
        ),
    
    
      ]
      );
  }
}
