import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:progress_hud/progress_hud.dart';
import 'track_page.dart';
import 'helpers/common.dart';
import 'dialogs/localisation_dialog.dart';
import 'drawer.dart';
import 'animations/animated_gps.dart';
import 'dart:async';
import 'services/service_help_request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dialogs/dialog_error_webservice.dart';
import 'models/trigger_event.dart';
import 'models/service_provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _isWitness = false;
  var _currentLocation = <String, double>{};
  ProgressHUD _progressHUD;
  bool _showProgressBar = true;

  AnimationController controller;
  Animation<double> animation;

  //Triggering events
  TriggerEvent accidentEvent = new TriggerEvent("Accident");
  TriggerEvent healthEvent = new TriggerEvent("Health");
  TriggerEvent assaultEvent = new TriggerEvent("Assault");
  TriggerEvent fireEvent = new TriggerEvent("Fireman");
  TriggerEvent thiefEvent = new TriggerEvent("Thief");
  TriggerEvent drowningEvent = new TriggerEvent("Drowning");
  TriggerEvent trackmeEvent = new TriggerEvent("Track me");

//initialise animation
  initState() {
    super.initState();

    getLocalisation(context);

    WidgetsBinding.instance.addObserver(this);

    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = new Tween(begin: 0.0, end: 100.0).animate(controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    //initiate progress hud
    _progressHUD = new ProgressHUD(
        backgroundColor: Colors.black54,
        color: Colors.white,
        containerColor: Colors.red,
        borderRadius: 5.0,
        text: 'Loading...');

    //call webservice to check if any live request
    getDeviceUID().then((uiD) {
      ServiceHelpRequest.retrieveLiveRequest(
          uiD.toString(), callbackWsGetExistingHelpReq);
    });
  }

  //callback webservice
  void callbackWsGetExistingHelpReq(http.Response response) {
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        if (decodedResponse["status"] == true) {
          if (decodedResponse["help_details"] == null) {
            print("No pending help request");
          } else {
            //open tracking page
            /*Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) =>
                    new TrackingPage(serviceProviders: serviceProviders),
              ),
            );*/
          }
        } else {
          //show error dialog
          showDataConnectionError(
              context, wsUserError, decodedResponse["error"]);
        }
      } else {
        //show error dialog
        showDataConnectionError(context, wsTechnicalError);
      }
    } catch (e) {
      showDataConnectionError(context, wsTechnicalError);
    }

    setState(() {
      if (_progressHUD != null) {
        _progressHUD.state.dismiss();
      }
    });
  }

  void _toggleWitness() {
    setState(() {
      _isWitness = !_isWitness;
    });
  }

  void changeToggle(newValue) {
    _isWitness = newValue;
  }

//retrieve localisation
  void getLocalisation(BuildContext context) async {
    var location = new Location();
    try {
      _currentLocation = await location.getLocation;
      myLocation.latitude = _currentLocation["latitude"];
      myLocation.longitude = _currentLocation["longitude"];

      location.onLocationChanged.listen((Map<String, double> currentLocation) {
        myLocation.latitude = currentLocation["latitude"];
        myLocation.longitude = currentLocation["longitude"];
      });
      print('success localisation' + _currentLocation.toString());
      controller.reset();
      controller.stop(canceled: true);
      //} catch (PlatformException, e) {
    } on PlatformException {
      _currentLocation = null;
      print('failed localisation ');
      //show localisation popup if gps settings is not opened
      if (!isLocationSettingsOpened) {
        showLocalisationSettingsDialog(context);
      }

      //launch animation
      controller.forward();
    }
  }

  @override

  //build main widget
  Widget build(BuildContext context) {
    //photo
    var avatarCircle = new Center(
      child: new CircleAvatar(
        backgroundImage: new AssetImage('images/pic_avatar.jpg'),
        radius: 50.0,
      ),
    );

    //name
    var nameHeader = new Container(
      padding: new EdgeInsets.all(5.0),
      height: 150.0,
      color: Colors.grey[300],
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [avatarCircle, new Text('Cedric Azemia')],
      ),
    );

    //witness switch
    var switchWitness = new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        new Icon(Icons.remove_red_eye),
        new Switch(
          value: _isWitness,
          onChanged: changeToggle,
        )
      ],
    );

    //triggered button
    Widget generateEventIconButton(TriggerEvent event) {
      var iconButton = new IconButton(
        //icon: new Icon(sp.iconInfo.iconData),
        icon: ImageIcon(event.icon.iconImage),
        iconSize: 65.0,
        color: event.icon.iconColor,
        tooltip: event.name,
        onPressed: () {
          if (_currentLocation != null) {
            initHelpRequest(event);
          } else {
            //try to get location
            getLocalisation(context);
          }
        },
      );

      var buttonColumn = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconButton,
          new Text(
            event.name,
            style: new TextStyle(fontSize: 15.0),
          ),
        ],
      );
      return buttonColumn;
    }

    var eventButtons = new Container(
        padding: new EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 5.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                new Container(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                    child: generateEventIconButton(accidentEvent)),
                new Container(
                    padding: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: generateEventIconButton(assaultEvent)),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                generateEventIconButton(thiefEvent),
                new Container(
                  padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: generateEventIconButton(healthEvent),
                ),
                generateEventIconButton(drowningEvent),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                new Container(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                    child: generateEventIconButton(fireEvent)),
                new Container(
                    padding: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: generateEventIconButton(trackmeEvent)),
              ],
            )
          ],
        ));

    var contentBody = new Container(
      padding: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      child: new Column(
        children: [switchWitness],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: appTitleBar),
      body: new Stack(
        children: [
          new Column(
            children: [
              nameHeader,
              AnimatedGPSStatus(
                animation: animation,
              ),
              contentBody,
              eventButtons,
            ],
          ),
          _progressHUD,
        ],
      ),

      drawer: buildDrawer(context),
      /*floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initHelpRequest(TriggerEvent event) {
    if (_progressHUD != null) {
      _progressHUD.state.show();
    }

    //initiate help request service
    getDeviceUID().then((uiD) {
      ServiceHelpRequest.initiateHelpRequest(
          uiD,
          myLocation.longitude.toStringAsPrecision(10),
          myLocation.latitude.toStringAsPrecision(10),
          event.serviceProviders,
          openTrackingPage);
    });
  }

  void openTrackingPage(
      http.Response response, List<ServiceProvider> serviceProviders) {
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        if (decodedResponse["status"] == true) {
          print("Help request id" + decodedResponse["id"].toString());

          //switch to patrol view
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) =>
                  new TrackingPage(serviceProviders: serviceProviders),
            ),
          );
        } else {
          //show error dialog
          showDataConnectionError(
              context, wsUserError, decodedResponse["error"]);
        }
      } else {
        //show error dialog
        showDataConnectionError(context, wsTechnicalError);
      }
    } catch (e) {
      showDataConnectionError(context, wsTechnicalError);
    }

    if (_progressHUD != null) {
      _progressHUD.state.dismiss();
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.resumed) {
        //app is resume i.e gps settings is no more opened
        isLocationSettingsOpened = false;

        //get localisation after 2 secs
        var callGpsLocalisation = () {
          getLocalisation(context);
        };

        var timer = new Timer(new Duration(seconds: 2), callGpsLocalisation);
      }
    });
  }
}
