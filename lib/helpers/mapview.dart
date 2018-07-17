import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:map_view/map_view.dart';
import 'constants.dart';
import '../helpers/webservice_wrappers.dart';
import 'common.dart';
import 'dart:async';
import '../models/service_provider.dart';
import '../models/help_request.dart';

class TrackingMap {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;

  Location myCurrentLocation;
  var compositeSubscription = new TrackingCompositeSubscription();
  String _spETA = "";

  List<ServiceProvider> serviceProviders;
  HelpRequest helpRequest;
  Timer timerRefreshLocation;
  BuildContext parentContext;

  TrackingMap(List<ServiceProvider> serviceProviders, HelpRequest helpRequest,
      BuildContext context) {
    this.serviceProviders = serviceProviders;
    this.helpRequest = helpRequest;

    this.parentContext = context;
    /* Scaffold.of(parentContext).showSnackBar(new SnackBar(
      content: new Text("Sending Message"),
    ));*/
  }

  Marker generateMarker(ServiceProvider sp) {
    var spMarker = new Marker(
        sp.uid, sp.name, sp.location.latitude, sp.location.longitude,
        color: sp.iconInfo.iconColor);

    return spMarker;
  }

  //get live request details
  getPendingHelpRequestFromServer() {
    print('call getPendingHelpRequestFromServer 2');
    WebserServiceWrapper.getPendingHelpRequest(callbackWsGetExistingHelpReq);
  }

  callbackWsGetExistingHelpReq(HelpRequest helpRequest, Exception e) {
    print('call callbackWsGetExistingHelpReq 2');
    if (e == null) {
      if (helpRequest != null) {
        for (var sp in helpRequest.serviceProviderObjects) {
          if ((!sp.isOptional) && (sp.location.hasBeenLocated)) {
            callUpdateSPLocation(sp);
          }
        }
      } else {
        print(wsUserError);
      }
    } else {
      if (e.toString().startsWith(wsUserError)) {
        print(wsUserError + ':' + e.toString());
      } else {
        print(wsTechnicalError + ": " + e.toString());
      }
    }
  }

  void callUpdateSPLocation(ServiceProvider newSp) {
    //locate service provider
    for (var sp in serviceProviders) {
      if (sp.name == newSp.name) {
        print('update ' + newSp.name);

        sp.location = newSp.location;
        sp.status = newSp.status;
        _spETA = sp.status.estTimeArrival;

        mapView.removeMarker(sp.marker);

        Marker myServiceProviderLocationMarker = generateMarker(sp);
        sp.marker = myServiceProviderLocationMarker;
        mapView.addMarker(sp.marker);
      }
    }
  }

  showMap() {
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new CameraPosition(
                new Location(myLocation.latitude, myLocation.longitude), 1.0),
            title: ""),
        toolbarActions: [new ToolbarAction("Cancel", 1)]);

    var sub = mapView.onMapReady.listen((_) {
      //for each service providers
      for (var sp in serviceProviders) {
        if ((!sp.isOptional) && (sp.location.hasBeenLocated)) {
          //generate Marker
          sp.marker = generateMarker(sp);

          //add marker to map
          mapView.addMarker(sp.marker);

        }
      }

      timerRefreshLocation = new Timer.periodic(updateStatusRefreshSec,
          (Timer t) => getPendingHelpRequestFromServer());

      //add own location
      var myLocationMarker = new Marker(
        "1",
        "My location",
        myLocation.latitude,
        myLocation.longitude,
        color: Colors.blue,
      );
      mapView.addMarker(myLocationMarker);

      //adjust zoom
      mapView.zoomToFit(padding: 100);
    });

    compositeSubscription.add(sub);

     /*sub = mapView.onLocationUpdated
        .listen((location) => print("Location updated $location"));
    compositeSubscription.add(sub);

    sub = mapView.onTouchAnnotation
        .listen((annotation) => print("annotation tapped"));
    compositeSubscription.add(sub);

    sub = mapView.onMapTapped
        .listen((location) => print("Touched location $location"));
    compositeSubscription.add(sub);

   sub = mapView.onCameraChanged.listen((cameraPosition) =>
        this.setState(() => this.cameraPosition = cameraPosition));
    compositeSubscription.add(sub);*/

    sub = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        handleDismiss();
      }
    });
    compositeSubscription.add(sub);

    sub = mapView.onInfoWindowTapped.listen((marker) {
      print("Info Window Tapped for ${marker.title}");
    });
    compositeSubscription.add(sub);
  }

  handleDismiss() async {
    print("handle dismiss triggered");
    timerRefreshLocation.cancel();

    mapView.dismiss();
    compositeSubscription.cancel();
  }
}

class TrackingCompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}
