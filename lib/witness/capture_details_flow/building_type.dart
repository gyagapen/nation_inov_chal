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
        title: new Text('Building Type'),
        content: new SingleChildScrollView(
                    child: new ListBody(
            children: <Widget>[
              new Text('Please select the building type'),
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
  
    List<String> _buildingTypes = ['Residential', 'Commercial', 'Industrial'];
    String _selectedBuildingType = "Residential";


  @override
  void initState(){
    super.initState();
    widget.witnessDetails.buildingType = _selectedBuildingType;
  }


  @override
  Widget build(BuildContext context) {
   return new DropdownButton(
      items: _buildingTypes.map((String val) {
        return new DropdownMenuItem<String>(
          value: val,
          child: new Text(val),
        );
      }).toList(),
      value: _selectedBuildingType,
      onChanged: (newValue) {
        setState(() {
          _selectedBuildingType = newValue;
          widget.witnessDetails.buildingType = _selectedBuildingType;
        });
      },
    );
  }
}

