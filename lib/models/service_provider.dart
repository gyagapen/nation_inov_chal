import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'custom_location.dart';


class ServiceProvider {
  String uid = "";
  String name = "";
  ServiceProviderStatus status = new ServiceProviderStatus();
  ServiceProviderIcon iconInfo = ServiceProviderIcon();
  CustomLocation location = new CustomLocation();
  Marker marker;
  bool isOptional;

  ServiceProvider(String name, [isOptional = false]) {
    this.name = name;
    this.isOptional = isOptional;

    switch (this.name) {
      case "Police":
        this.iconInfo.iconImage = new AssetImage("images/policeman.png");
        this.iconInfo.iconColor = Colors.blue[500];
        this.iconInfo.highlightColor1 = Colors.red;
        this.iconInfo.highlightColor2 = Colors.blue;
        break;
      case "SAMU":
        this.iconInfo.iconImage = new AssetImage("images/health.png");
        this.iconInfo.iconColor = Colors.red[500];
        this.iconInfo.highlightColor1 = Colors.red;
        this.iconInfo.highlightColor2 = Colors.black;
        break;
      case "Fireman":
        this.iconInfo.iconImage = new AssetImage("images/fireman.png");
        this.iconInfo.iconColor = Colors.orange[500];
        this.iconInfo.highlightColor1 = Colors.orange;
        this.iconInfo.highlightColor2 = Colors.black;
        break;
      case "Coast Guard":
        this.iconInfo.iconImage = new AssetImage("images/coastguard.png");
        this.iconInfo.iconColor = Colors.green[500];
        this.iconInfo.highlightColor1 = Colors.green;
        this.iconInfo.highlightColor2 = Colors.black;
        break;
    }
  }
}

class ServiceProviderStatus {
  ///status of service provider
  /// 0: Contacting
  /// 1: In transit
  /// 2: Arrived
  /// 4: Other
  int value = 0;

  //ETA in minutes
  int estTimeArrival = 0;

  String getStatusText() {
    String descText = "";

    switch (value) {
      case 0:
        descText = "Contacting...";
        break;
      case 1:
        descText = "In Transit";
        break;
      case 2:
        descText = "Arrived";
        break;
    }

    return descText;
  }
}

class ServiceProviderIcon {
  AssetImage iconImage;
  Color iconColor;
  Color highlightColor1 = Colors.black;
  Color highlightColor2 = Colors.black;
}

