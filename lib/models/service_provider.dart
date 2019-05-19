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
  String trackingImage = "";
  bool isOptional;

  ServiceProvider(String name, [isOptional = false]) {
    this.name = name;
    this.isOptional = isOptional;

    switch (this.name) {
      case "Police":
        this.iconInfo.iconImage = "images/policeman.png";
        this.iconInfo.iconColor = Colors.blue[500];
        this.iconInfo.highlightColor1 = Colors.red;
        this.iconInfo.highlightColor2 = Colors.blue;
        break;
      case "SAMU":
        this.iconInfo.iconImage = "images/hospital.png";
        this.iconInfo.iconColor = Colors.red[500];
        this.iconInfo.highlightColor1 = Colors.red;
        this.iconInfo.highlightColor2 = Colors.black;
        trackingImage = "images/ambulance.png";
        break;
      case "Fireman":
        this.iconInfo.iconImage = "images/fireman.png";
        this.iconInfo.iconColor = Colors.orange[500];
        this.iconInfo.highlightColor1 = Colors.orange;
        this.iconInfo.highlightColor2 = Colors.black;
        trackingImage = "images/firetruck.png";
        break;
      case "Coast Guard":
        this.iconInfo.iconImage = "images/coastguard.png";
        this.iconInfo.iconColor = Colors.green[500];
        this.iconInfo.highlightColor1 = Colors.green;
        this.iconInfo.highlightColor2 = Colors.black;
        trackingImage = "images/boat.png";
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
  String estTimeArrival = "";

  //distance in km
  String distanceKm = "";

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

  void setStatusFromWs(String wsStatus) {
    switch (wsStatus) {
      case "TRANSIT":
        this.value = 1;
        break;
      case "ARRIVED":
        this.value = 2;
        break;
    }
  }
}

class ServiceProviderIcon {
  String iconImage;
  Color iconColor;
  Color highlightColor1 = Colors.black;
  Color highlightColor2 = Colors.black;
}
