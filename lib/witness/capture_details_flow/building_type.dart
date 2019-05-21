import 'package:flutter/material.dart';
import 'flow_manager.dart';
import 'dart:async';
import '../../models/witness_details.dart';

import 'package:mausafe_v0/models/trigger_event.dart';

const String BUILDING_TYPE_DIALOG_ID = "building_type_dialog";

Future<Null> showBuildingTypeDialog(WitnessDetails witnessDetails,
    BuildContext context, TriggerEvent id, callback) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

      return new AlertDialog(
        title: new Text('Building type?'),
        content: new SingleChildScrollView(
                    child: new ListBody(
            children: <Widget>[
              BuildingTypeDialogContent(witnessDetails: witnessDetails,),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Back'),
              onPressed: () {
                Navigator.pop(context);
                WitnessFlowManager.showWitnessPreviousStep(BUILDING_TYPE_DIALOG_ID, witnessDetails, context, id, callback);
              }),
          new FlatButton(
              child: new Text('Next'),
              onPressed: () {
                Navigator.pop(context);
                WitnessFlowManager.showWitnessNextStep(BUILDING_TYPE_DIALOG_ID, witnessDetails, context, id, callback);
              }),
        ],
      );
    },
  );
}


class BuildingTypeDialogContent extends StatefulWidget {
  BuildingTypeDialogContent({
    Key key,
    this.witnessDetails,
  }): super(key: key);

  WitnessDetails witnessDetails;

  @override
  _BuildingTypeDialogContentState createState() => new _BuildingTypeDialogContentState();
}

class _BuildingTypeDialogContentState extends State<BuildingTypeDialogContent> {
  
  String _selectedBuildingType = "Residential";
  double iconWidth = 30.0;
  double iconHeight = 30.0;
  double textSize = 15.0;

  @override
  void initState(){
    super.initState();
    widget.witnessDetails.buildingType = _selectedBuildingType;
  }

   void _handleRadioValueChange(String value) {
      setState(() {
        _selectedBuildingType = value;
        widget.witnessDetails.buildingType = _selectedBuildingType;
      });
  }



  @override
  Widget build(BuildContext context) {

    return 
    new Column(
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
                Image.asset("images/witness/Residential.png", height: iconHeight, width: iconWidth,),
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 0.0),
                  child: new Text("Residential", style: new TextStyle(fontSize: textSize),),
                ),
                new Radio(
                    value: "Residential",
                    groupValue: _selectedBuildingType,
                    onChanged: _handleRadioValueChange,
                  )
              ],
            ),
             new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset("images/witness/Commercial.png", height: iconHeight, width: iconWidth,),
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 0.0),
                  child: new Text("Commercial",style: new TextStyle(fontSize: textSize)),
                ),
                new Radio(
                    value: "Commercial",
                    groupValue: _selectedBuildingType,
                    onChanged: _handleRadioValueChange,
                  )
              ],
            ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset("images/witness/industrial.png", height: iconHeight, width: iconWidth,),
                  new Container(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: new Text("Industrial", style: new TextStyle(fontSize: textSize)),
                  ),
                  new Radio(
                      value: "Industrial",
                      groupValue: _selectedBuildingType,
                      onChanged: _handleRadioValueChange,
                    )
              ],
            )
          ],
        ),
    
    
      ]
      );
  }
}

