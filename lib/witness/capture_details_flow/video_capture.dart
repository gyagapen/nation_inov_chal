import 'package:flutter/material.dart';
import 'building_type.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import '../../helpers/common.dart';

import 'package:mausafe_v0/models/trigger_event.dart';

Future<Null> showVideoCaptureDialog(
    BuildContext context, TriggerEvent id, callback) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

      //init cameras
      CameraController controller =CameraController(cameras[0], ResolutionPreset.medium);
      controller.initialize();

      return new AlertDialog(
        title: new Text('Sinister Details'),
        content:
        new Container(
          height: 100,
          child: new AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
        )
        
        /*new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Please select the sinister type'),
            ],
          ),
          //child: new MyStepperPage(),
        )*/,
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
                showBuildingTypeDialog(context, id, callback);
              }),
        ],
      );
    },
  );
}
