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
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
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
  
    //List<String> _buildingTypes = ['Residential', 'Commercial', 'Industrial'];
    String _selectedBuildingType = "Residential";


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
                new ImageIcon(new AssetImage("images/witness/Residential.png"), size: 30.0,),
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 0.0),
                  child: new Text("Residential"),
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
                new ImageIcon(new AssetImage("images/witness/Commercial.png"), size: 30.0,),
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 0.0),
                  child: new Text("Commercial"),
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
                  new ImageIcon(new AssetImage("images/witness/industrial.png"), size: 30.0,),
                  new Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: new Text("Industrial"),
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

