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
        title: new Text('Sinister Details'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Please select the sinister type'),
              new SinisterDialogContent(witnessDetails: witnessDetails,),
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
  
  List<String> _sinisterTypes = ['Building', 'Field', 'Vehicle', 'Rubbish'];
  String _selectedSinisterType = "Building";


  @override
  void initState(){
    super.initState();
    widget.witnessDetails.impactType = _selectedSinisterType;
  }


  @override
  Widget build(BuildContext context) {
   return new DropdownButton(
      items: _sinisterTypes.map((String val) {
        return new DropdownMenuItem<String>(
          value: val,
          child: new Text(val),
        );
      }).toList(),
      value: _selectedSinisterType,
      onChanged: (newValue) {
        setState(() {
          _selectedSinisterType = newValue; 
          widget.witnessDetails.impactType = _selectedSinisterType;
        });
      },
    );
  }
}
