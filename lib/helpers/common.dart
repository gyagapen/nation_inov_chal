import 'package:flutter/material.dart';
import '../models/custom_location.dart';
import '../models/service_provider.dart';
import 'dart:async';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart' show PlatformException;
import '../notification_list.dart';

//common variables
bool isLocationSettingsOpened = false;
String wsTechnicalError =
    "Cannot contact MauSafe servers. Kindly ensure that you are connected to internet";
String wsUserError =
    "Error while sending request to MauSafe servers. Error Details: ";

String storedUiD = "";

bool refreshCircleList = false;

Widget getAppTitleBar(BuildContext context) {
  var appTitleBar = new Container(
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        new ImageIcon(
          AssetImage("images/general_logo.png"),
          size: 100.0,
        ),
        new Container(
          padding: new EdgeInsets.fromLTRB(120.0, 0.0, 0.0, 0.0),
          child: new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new NotificationListPage(),
                ),
              );
            },
            child: new Stack(
              children: <Widget>[
                new Icon(
                  Icons.notifications,
                  size: 30.0,
                ),
                new Positioned(
                  top: 1.0,
                  right: 0.0,
                  child: new Stack(
                    children: <Widget>[
                      new Icon(Icons.brightness_1,
                          size: 18.0, color: Colors.green[800]),
                      new Positioned(
                        top: 1.0,
                        right: 4.0,
                        child: new Text("1",
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        //new Text(appTitleBarText),
      ],
    ),
  );

  return appTitleBar;
}

//custom locations
CustomLocation myLocation = new CustomLocation();
//CustomLocation myServiceProviderLocation = new CustomLocation();

void UpdateServiceProviderLocation(
    ServiceProvider sp, callback(ServiceProvider newSp)) async {
  await new Future.delayed(const Duration(seconds: 5)).then((_) {
    print('UpdateServiceProviderLocation');
    sp.location.hasBeenLocated = true;
    sp.location.latitude -= 0.0005;
    callback(sp);
  });
}

//get service provider status
void UpdateServiceProviderStatus(
    ServiceProvider sp, callback(ServiceProvider newSp)) async {
  await new Future.delayed(const Duration(seconds: 5)).then((_) {
    sp.status.value = 1;
    sp.status.estTimeArrival = "15m";
    switch (sp.name) {
      case "Police":
        sp.uid = "2";
        sp.location.latitude = -20.239782;
        sp.location.longitude = 57.456596;
        break;
      case "SAMU":
        sp.uid = "3";
        sp.location.latitude = -20.239782;
        sp.location.longitude = 57.456596;
        break;
      case "Fireman":
        sp.uid = "4";
        sp.location.latitude = -20.239782;
        sp.location.longitude = 57.446496;
        break;
      case "Coast Guard":
        sp.uid = "5";
        sp.location.latitude = -20.239782;
        sp.location.longitude = 57.436396;
        break;
    }
  });

  callback(sp);
}

//mapping for service provider
List<ServiceProvider> getListOfServiceProviders(String event) {
  List<ServiceProvider> serviceProviders = new List<ServiceProvider>();

  switch (event) {
    case "Accident":
      serviceProviders.add(new ServiceProvider("Police"));
      serviceProviders.add(new ServiceProvider("SAMU"));
      serviceProviders.add(new ServiceProvider("Fire"));
      break;
    case "Health":
      serviceProviders.add(new ServiceProvider("SAMU"));
      break;
    case "Fire":
      serviceProviders.add(new ServiceProvider("Fire"));
      serviceProviders.add(new ServiceProvider("SAMU"));
      break;
    case "Assault":
      serviceProviders.add(new ServiceProvider("Police"));
      serviceProviders.add(new ServiceProvider("SAMU"));
      break;
  }

  return serviceProviders;
}

//get device UUID
Future<String> getDeviceUID() async {
  String deviceName;
  String deviceVersion;
  String identifier;
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  try {
    var build = await deviceInfoPlugin.androidInfo;
    identifier = build.id;
    deviceName = build.model;
    deviceVersion = build.version.toString();
  } on PlatformException {
    print('Failed to get platform version');
  }

//if (!mounted) return;
  return identifier + "-" + deviceName;
}
