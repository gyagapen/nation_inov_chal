import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'home.dart';
import 'helpers/constants.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'helpers/common.dart';

Future<void> main() async {
  MapView.setApiKey(gmapsApiKey);


  //init cameras
  cameras = await availableCameras();
  cameraController =CameraController(cameras[0], ResolutionPreset.medium);
  cameraController.initialize().then((v){
    print("Camera initialized");
  }).catchError((e)
  {
    print("Camera not initialized: "+e.toString());
  });
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitleBarText,
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(title: 'MauSafe'),
    );
  }
}
