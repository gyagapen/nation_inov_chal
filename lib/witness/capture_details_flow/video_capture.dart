import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import '../../helpers/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/witness_details.dart';
import 'flow_manager.dart';

import 'package:mausafe_v0/models/trigger_event.dart';

const String VIDEO_CAPTURE_DIALOG_ID = "video_capture_dialog";

Future<Null> showVideoCaptureDialog(WitnessDetails witnessDetails,
    BuildContext context, TriggerEvent id, callback) async {

   void _showCameraException(CameraException e) {
      String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
      print(errorText);
  
      Fluttertoast.showToast(
          msg: 'Error: ${e.code}\n${e.description}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }

     Future<String> _startVideoRecording() async {
    if (!cameraController.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white
      );
 
      return null;
    }


 
    // Do nothing if a recording is on progress
    if (cameraController.value.isRecordingVideo) {
      return null;
    }
 
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/${currentTime}.mp4';
 
    try {
      await cameraController.startVideoRecording(filePath);
      witnessDetails.videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
 
    return filePath;
  }

  void _onRecordButtonPressed() {
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        Fluttertoast.showToast(
            msg: 'Recording video started',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white
        );
      }
    });
  }

  Future<void> _stopVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }
 
    try {
      await cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _onStopButtonPressed() {
    _stopVideoRecording().then((_) {
      Fluttertoast.showToast(
          msg: 'Video recorded to ${witnessDetails.videoPath}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white
      );
    });
  }
 
 

  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

      

      return new AlertDialog(
        title: new Text('Sinister Details'),
        content:
        new Container(
              height: 600,
              child:
        new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            new Container(
              height: 500,
              child: new AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
              ),
            ),
            new Row(
              children: [
                new FlatButton(
                  child: new Text("Start Recording"),
                  onPressed: _onRecordButtonPressed
                ),
                new FlatButton(
                  child: new Text("Stop Recording"),
                  onPressed: _onStopButtonPressed
                )
              ],
            )
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
                WitnessFlowManager.showWitnessNextStep(VIDEO_CAPTURE_DIALOG_ID, witnessDetails, context, id, callback);
              }),
        ],
      );
    },
  );
}
