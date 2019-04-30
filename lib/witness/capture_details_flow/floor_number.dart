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
        title: new Text('Floor Details'),
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


  @override
  void initState(){
    super.initState();
  }

  @override
  /*Widget build(BuildContext context) {
   return new Form(
      key: widget.formKey,
      child: new Column(
        children: [
          new Container(
            margin: new EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 15.0),
            child: new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                if(!isNumeric(value))
                {
                  return 'Please enter a numeric value';
                }
              },
              initialValue: "0",
              onSaved: (val) => widget.witnessDetails.noOfFloors = int.parse(val),
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                hintText: '',
                hintStyle: new TextStyle(fontStyle: FontStyle.italic),
                labelText: 'Number or floors',
                labelStyle: new TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          ],
      ),
        
      );
  }*/

  Widget build(BuildContext context) {
      return  new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new TextFormField(
            decoration: new InputDecoration(labelText: "Number or floor(s)"),
            initialValue: "0",
            keyboardType: TextInputType.number,
            onSaved: (newValue) {
        setState(() {
          widget.witnessDetails.noOfFloors = int.parse(newValue);
        });
      },
          ),
        ],
      );
  }
}
