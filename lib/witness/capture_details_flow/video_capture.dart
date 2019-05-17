import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import '../../helpers/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/witness_details.dart';
import 'flow_manager.dart';
import '../../helpers/utilities.dart';

import 'package:mausafe_v0/models/trigger_event.dart';

const String VIDEO_CAPTURE_DIALOG_ID = "video_capture_dialog";
CameraController cameraController;

Future<Null> showVideoCaptureDialog(WitnessDetails witnessDetails,
    BuildContext context, TriggerEvent id, callback) async {

   
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

      double windowHeight = MediaQuery.of(context).size.height;
      double windowWidth = MediaQuery.of(context).size.width;
      

      return new AlertDialog(
        title: new Text('Record a video'),
        content: 
        new Container(
              height: windowHeight*0.8,
              child:
              new VideoCaptureContent(witnessDetails: witnessDetails,
                                        windowHeight: windowHeight,
                                        windowWidth: windowWidth,)
        )
        ,
        actions: <Widget>[
          new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: new Text('Complete'),
              onPressed: () {
                if(witnessDetails.videoPath != "")
                {
                  if(cameraController != null)
                  {
                    cameraController.dispose();
                  }
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
    this.windowHeight,
    this.windowWidth
  }): super(key: key);

  WitnessDetails witnessDetails;
  double windowHeight;
  double windowWidth;

  @override
  _VideoCaptureContentState createState() => new _VideoCaptureContentState();
}

class _VideoCaptureContentState extends State<VideoCaptureContent> {

  int _secondRecorded = 0;
  int _maxAllowDuration = 30;
  String _videoPath = "";
  Timer _timer;
  bool _isRecording = false;
  bool _cameraMounted = false;

  void onSecondRecorded(Timer t)
  {
    
    if(_secondRecorded == _maxAllowDuration){
      _stopVideoRecording();
      _timer.cancel();
    } else if(_secondRecorded < _maxAllowDuration)
    {
        setState(() {
      _secondRecorded++; 
      });
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
    
    if(_videoPath != "")
    {
      deleteFile(_videoPath);
    }
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
 
    setState(() {
     _secondRecorded  = 0;
    });

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
      setState(() {
       _isRecording = false; 
       _timer.cancel();
      widget.witnessDetails.videoPath = _videoPath;
      print("Video temporaly saved to ${widget.witnessDetails.videoPath}");
      });
      
    });
  }
 
 

  @override
  void initState(){
    super.initState();
    initCameraController();

  }

  Future<void> initCameraController() async{
      cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      cameraController.initialize().then((v){
        print("Camera initialized");
        setState(() {
          _cameraMounted = true;
        });
        
      }).catchError((e)
      {
        print("Camera not initialized: "+e.toString());
      });
  }

  Widget getCameraContent()
  {
    if(!_cameraMounted)
    {
      return new Container();
    } else
    {
      return new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            new Text("$_secondRecorded/${_maxAllowDuration}s"),
            new Container(
              height: widget.windowHeight*0.54,
              child: new AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
              ),
            ),
            new IconButton(
              icon: new Icon(_isRecording? Icons.stop : Icons.camera, color: Colors.red,),
              onPressed: _onCameraButtonPressed,
            )
          ],
        
        );
    }
  }

  @override
  Widget build(BuildContext context) {
   return getCameraContent();
       
  }

}
