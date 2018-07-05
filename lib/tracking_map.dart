import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:map_view/map_view.dart';
import 'helpers/constants.dart';
import 'helpers/common.dart';
import 'helpers/common_objects.dart';
import 'dart:async';

class TrackingMapPage extends StatefulWidget {
  _TrackingMapPageState createState() => new _TrackingMapPageState();
}

class _TrackingMapPageState extends State<TrackingMapPage>
    with WidgetsBindingObserver {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  int _spETA = 0;
  Location myCurrentLocation;
  var compositeSubscription = new CompositeSubscription();
  var staticMapProvider = new StaticMapProvider(gmapsApiKey);
  Uri staticMapUri;
  Timer updateSPLocTimer;
  MapView generateAMap() {
    MapView newMapView = new MapView();

    newMapView.setCameraPosition(myLocation.latitude, myLocation.longitude, 1.0);

    //add markers
    /*var myLocationMarker = new Marker(
      "1",
      "My location",
      myLocation.latitude,
      myLocation.longitude,
      color: Colors.blue[500],
    );

    var myServiceProviderLocationMarker = new Marker("2", "Police",
        myServiceProviderLocation.latitude, myServiceProviderLocation.longitude,
        color: Colors.red[500]);

    newMapView.addMarker(myLocationMarker);

    newMapView.addMarker(myServiceProviderLocationMarker);*/
    //newMapView.zoomToFit(padding: 100); 

    return newMapView;
  }

  Future<Uri> generateStaticMap() async{
    
    var uri = await staticMapProvider.getImageUriFromMap(generateAMap(),
        width: 900, height: 400);

    return uri;
  }

  initState() {
    super.initState();

    /*myServiceProviderLocation.latitude = -20.239782;
    myServiceProviderLocation.longitude = 57.456596;*/

    myCurrentLocation = new Location(myLocation.latitude, myLocation.longitude);
    cameraPosition = new CameraPosition(myCurrentLocation, 2.0);
    staticMapUri = staticMapProvider.getStaticUri(myCurrentLocation, 12,
        width: 900, height: 400, mapType: StaticMapViewType.roadmap);

  }

  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Map View Example'),
          ),
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                height: 250.0,
                child: new Stack(
                  children: <Widget>[
                    new Center(
                        child: new Container(
                      child: new Text(
                        "You are supposed to see a map here.\n\nAPI Key is not valid.\n\n"
                            "To view maps in the example application set the "
                            "API_KEY variable in example/lib/main.dart. "
                            "\n\nIf you have set an API Key but you still see this text "
                            "make sure you have enabled all of the correct APIs "
                            "in the Google API Console. See README for more detail.",
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(20.0),
                    )),
                    new InkWell(
                      child: new Center(
                        child: new Image.network(staticMapUri.toString()),
                        //child: new Image.network(generateStaticMap().toString()),
                      ),
                      onTap: showMap,
                    )
                  ],
                ),
              ),
              new Container(
                padding: new EdgeInsets.only(top: 10.0),
                child: new Text(
                  "Tap the map to interact",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new Container(
                padding: new EdgeInsets.only(top: 25.0),
                child: new Text(
                    "Camera Position: \n\nLat: ${cameraPosition.center.latitude}\n\nLng:${cameraPosition.center.longitude}\n\nZoom: ${cameraPosition.zoom}"),
              ),
            ],
          )),
    );
  }

  showMap() {
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new CameraPosition(
                new Location(myLocation.latitude, myLocation.longitude), 1.0),
            title: "ETA SAMU : ${_spETA}min"),
        toolbarActions: [new ToolbarAction("Cancel", 1)]);

    var sub = mapView.onMapReady.listen((_) {
      var myLocationMarker = new Marker(
        "1",
        "My location",
        myLocation.latitude,
        myLocation.longitude,
        color: Colors.blue[500],
      );

     /* var myServiceProviderLocationMarker = new Marker(
          "2",
          "Police",
          myServiceProviderLocation.latitude,
          myServiceProviderLocation.longitude,
          color: Colors.red[500]);

      mapView.addMarker(myLocationMarker);

      mapView.addMarker(myServiceProviderLocationMarker);
      mapView.zoomToFit(padding: 100);

      void callUpdateSPLocation(CustomLocation cl) {
        myServiceProviderLocation = cl;
        _spETA = 5;
        mapView.removeMarker(myServiceProviderLocationMarker);
        mapView.addMarker(new Marker(myServiceProviderLocationMarker.id,
            myServiceProviderLocationMarker.title, cl.latitude, cl.longitude,
            color: myServiceProviderLocationMarker.color));
      }

      updateSPLocTimer = new Timer.periodic(
          sPLocRefreshDuration,
          (Timer t) => UpdateServiceProviderLocation(
              myServiceProviderLocation, callUpdateSPLocation));*/
    });

    compositeSubscription.add(sub);

    sub = mapView.onLocationUpdated
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
    compositeSubscription.add(sub);

    sub = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        _handleDismiss();
      }
    });
    compositeSubscription.add(sub);

    sub = mapView.onInfoWindowTapped.listen((marker) {
      print("Info Window Tapped for ${marker.title}");
    });
    compositeSubscription.add(sub);
  }

  _handleDismiss() async {
    updateSPLocTimer.cancel();
    double zoomLevel = await mapView.zoomLevel;
    Location centerLocation = await mapView.centerLocation;
    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
    print("Zoom Level: $zoomLevel");
    print("Center: $centerLocation");
    print("Visible Annotation Count: ${visibleAnnotations.length}");
    var uri = await staticMapProvider.getImageUriFromMap(mapView,
        width: 900, height: 400);
    //setState(() => staticMapUri = uri);
    mapView.dismiss();
    compositeSubscription.cancel();
  }

  @override
  void dispose() {
    print("activity exit");
    _handleDismiss();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class CompositeSubscription {
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
