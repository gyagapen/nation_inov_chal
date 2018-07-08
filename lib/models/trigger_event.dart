import 'package:flutter/material.dart';
import 'service_provider.dart';

class TriggerEvent {
  String name;
  ServiceProviderIcon icon;
  List<ServiceProvider> serviceProviders;

  TriggerEvent(String name) {
    this.name = name;

    //populate Icon and service providers
    icon = new ServiceProviderIcon();
    serviceProviders = new List<ServiceProvider>();

    switch (name) {
      case "Accident":
        icon.iconImage = new AssetImage("images/accident.png");
        icon.iconColor = Colors.blue[500];

        serviceProviders.add(new ServiceProvider("Police"));
        serviceProviders.add(new ServiceProvider("SAMU"));
        serviceProviders.add(new ServiceProvider("Fireman", true));
        break;
      case "Health":
        icon.iconImage = new AssetImage("images/health.png");
        icon.iconColor = Colors.red[500];

        serviceProviders.add(new ServiceProvider("SAMU"));
        break;
      case "Assault":
        icon.iconImage = new AssetImage("images/assault.png");
        icon.iconColor = Colors.green[500];

        serviceProviders.add(new ServiceProvider("Fireman"));
        serviceProviders.add(new ServiceProvider("SAMU"));
        break;
      case "Fireman":
        icon.iconImage = new AssetImage("images/fire.png");
        icon.iconColor = Colors.orange[500];

        serviceProviders.add(new ServiceProvider("Police"));
        serviceProviders.add(new ServiceProvider("SAMU", true));
        break;
      case "Thief":
        icon.iconImage = new AssetImage("images/thief.png");
        icon.iconColor = Colors.indigo[500];

        serviceProviders.add(new ServiceProvider("Police"));
        serviceProviders.add(new ServiceProvider("SAMU", true));
        break;
      case "Drowning":
        icon.iconImage = new AssetImage("images/drowning.png");
        icon.iconColor = Colors.cyan[500];

        serviceProviders.add(new ServiceProvider("Police"));
        serviceProviders.add(new ServiceProvider("Coast Guard"));
        break;
      case "Track me":
        icon.iconImage = new AssetImage("images/track_me.png");
        icon.iconColor = Colors.lightGreen[500];

        serviceProviders.add(new ServiceProvider("Police"));
        break;
    }
  }
}
