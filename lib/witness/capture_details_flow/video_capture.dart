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

   
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

      

      return new AlertDialog(
        title: new Text('Record a video'),
        content: 
        new Container(
              height: 600,
              child:
              new VideoCaptureContent(witnessDetails: witnessDetails,)
        )
        ,
        actions: <Widget>[
          new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: new Text('Next'),
              onPressed: () {
                if(witnessDetails.videoPath != "")
                {
                  Navigator.pop(context);
                  WitnessFlowManager.showWitnessNextStep(VIDEO_CAPTURE_DIALOG_ID, witnessDetails, context, id, callback);
                } else
                {
                  Fluttertoast.showToast(
                  msg: 'You must capture a video',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white
        );
                }
              }),
        ],
      );
    },
  );
}


class VideoCaptureContent extends StatefulWidget {
  VideoCaptureContent({
    Key key,
    this.witnessDetails,
  }): super(key: key);

  WitnessDetails witnessDetails;

  @override
  _VideoCaptureContentState createState() => new _VideoCaptureContentState();
}

class _VideoCaptureContentState extends State<VideoCaptureContent> {

  int _secondRecorded = 0;
  int _maxAllowDuration = 30;
  String _videoPath = "";
  Timer _timer;
  bool _isRecording = false;

  void onSecondRecorded(Timer t)
  {
    setState(() {
     _secondRecorded++; 
    });
    if(_secondRecorded == _maxAllowDuration){
      _stopVideoRecording();
      _timer.cancel();
    }

    
  }

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
    
    _videoPath = "";
    widget.witnessDetails.videoPath = "";

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
      _videoPath = filePath;
      
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
 
    //start timer
    _timer = new Timer.periodic(new Duration(seconds: 1), onSecondRecorded);
    _isRecording = true;
    return filePath;
  }

  void _onCameraButtonPressed(){
    if(!_isRecording)
    {
      _onRecordButtonPressed();
    } else
    {
      _onStopButtonPressed();
    }
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
      _isRecording = false;
      print("Video temporaly saved to ${widget.witnessDetails.videoPath}");
      widget.witnessDetails.videoPath = _videoPath;
    });
  }
 
 

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
   return 
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            new Text("$_secondRecorded/${_maxAllowDuration}s"),
            new Container(
              height: 500,
              child: new AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
              ),
            ),
            /*new FlatButton(
              child: new Ic,
              onPressed: _onCameraButtonPressed
            ),*/
            new IconButton(
              icon: new Icon(_isRecording? Icons.stop : Icons.camera, color: Colors.red,),
              onPressed: _onCameraButtonPressed,
            )
          ],
        
        );
  }

}
