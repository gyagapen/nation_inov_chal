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
import 'models/help_request.dart';
import 'helpers/webservice_wrappers.dart';
import 'helpers/constants.dart';
import 'animations/animated_witness_switch.dart';
import 'witness/capture_details_flow/flow_manager.dart';
import 'models/witness_details.dart';

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
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _isWitness = false;
  var _currentLocation = <String, double>{};
  ProgressHUD _progressHUD;
  bool _dataConnectionAvailable = true;

  AnimationController controller;
  Animation<double> animation;

  AnimationController controllerSwitch;
  Animation<double> animationSwitch;

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
    _isWitness = false;
    WidgetsBinding.instance.addObserver(this);

    //controller and animation for gps
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

    //controller and animation for witness switch
    controllerSwitch = new AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    animationSwitch =
        new Tween(begin: 0.0, end: 100.0).animate(controllerSwitch);

    animationSwitch.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerSwitch.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controllerSwitch.forward();
      }
    });

    //launch switch animation
    controllerSwitch.forward();

    //initiate progress hud
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black54,
      color: Colors.white,
      containerColor: Colors.red[900],
      borderRadius: 5.0,
      text: 'Loading...',
    );

    if ((_progressHUD.state != null)) {
      _progressHUD.state.show();
    }
    getPendingHelpRequestFromServer();
  }

  //get live request details
  void getPendingHelpRequestFromServer() {
    WebserServiceWrapper.getPendingHelpRequest(
        callbackWsGetExistingHelpReq, "UID", "");
  }

  void callbackWsGetExistingHelpReq(HelpRequest helpRequest, Exception e) {
    if (_progressHUD.state != null) {
      _progressHUD.state.dismiss();
    }

    if (e == null) {
      setState(() {
        _dataConnectionAvailable = true;
      });

      if (helpRequest != null) {
        //open tracking page
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new TrackingPage(
                  helpRequest: helpRequest,
                ),
          ),
        );
      } else {
        getLocalisation(context);
      }
    } else {
      if (e.toString().startsWith(wsUserError)) {
        showDataConnectionError(
            context, wsUserError, e.toString().split("|").elementAt(1));
      } else {
        showDataConnectionError(
            context, wsTechnicalError + ": " + e.toString());

        setState(() {
          _dataConnectionAvailable = false;
        });
      }
    }
  }

//retrieve localisation
  void getLocalisation(BuildContext context) async {
    var location = new Location();
    try {
      _currentLocation = await location.getLocation();
      myLocation.latitude = _currentLocation["latitude"];
      myLocation.longitude = _currentLocation["longitude"];

      location.onLocationChanged().listen((Map<String, double> currentLocation) {
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
        backgroundImage: new AssetImage('images/black_avatar_4.png'),
        backgroundColor: Colors.white,
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
        children: [avatarCircle, new Text(customerName)],
      ),
    );

    var switchWitness = new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        new AnimatedWitnessSwitch(
          animation: animationSwitch,
        ),
        new Switch(
          value: _isWitness,
          onChanged: (value) {
            setState(() {
             _isWitness =value; 
            });
          },
        )
      ],
    );

    //triggered button
    Widget generateEventIconButton(TriggerEvent event) {
      /*var iconButton = new IconButton(
        //icon: new Icon(sp.iconInfo.iconData),
        icon: ImageIcon(event.icon.iconImage),
        iconSize: 65.0,
        color: event.icon.iconColor,
        tooltip: event.name,
        onPressed: () {
          if (_currentLocation != null) {
            if(_isWitness && event.name == "Fireman")
            {
              WitnessFlowManager.showWitnessNextStep("", new WitnessDetails(), context, event, initHelpRequest);
            } else
            {
                initHelpRequest(event, null);
            }
          } else {
            //try to get location
            getLocalisation(context);
          }
        },
      );*/


      var iconButton = new FlatButton(
        //icon: new Icon(sp.iconInfo.iconData),
        child: Image.asset(event.icon.iconImage, width: 65.0, height: 65.0,),
        onPressed: () {
          if (_currentLocation != null) {
            if(_isWitness && event.name == "Fireman")
            {
              WitnessFlowManager.showWitnessNextStep("", new WitnessDetails(), context, event, initHelpRequest);
            } else
            {
                initHelpRequest(event, null);
            }
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

    var mainPageContentWrapper = new Column(
      children: [
        nameHeader,
        AnimatedGPSStatus(
          animation: animation,
        ),
        contentBody,
        eventButtons,
      ],
    );

    var dataErrorRetryWrapper = new Column(
      children: [
        nameHeader,
        new Container(
          padding: new EdgeInsets.fromLTRB(5.0, 150.0, 5.0, 5.0),
          child: new Text(
            "Error while contacting Mausafe servers",
            style: new TextStyle(
                color: Colors.red[900], fontWeight: FontWeight.bold),
          ),
        ),
        new Container(
          padding: new EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 5.0),
          child: new RaisedButton(
            child: new Text("Retry"),
            onPressed: () {
              getPendingHelpRequestFromServer();
            },
          ),
        )
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: getAppTitleBar(context),
      ),
      body: new Stack(
        children: [
          _dataConnectionAvailable
              ? mainPageContentWrapper
              : dataErrorRetryWrapper,
          _progressHUD,
        ],
      ),
      drawer: buildDrawer(context),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initHelpRequest(TriggerEvent event, WitnessDetails witnessDetails) {
    if (_progressHUD.state != null) {
      _progressHUD.state.show();
    }

      if(witnessDetails != null && witnessDetails.isSAMUNeeded) {
        bool samuFound = false;
        for (int i = 0; i < event.serviceProviders.length; i++) {
          if (event.serviceProviders.elementAt(i).name == "SAMU") {
              event.serviceProviders.elementAt(i).isOptional = false;
              samuFound = true;
          }
        }
        if(!samuFound)
        {
          event.serviceProviders.add(new ServiceProvider("SAMU"));
        }
      } 
    //initiate help request service
    getDeviceUID().then((uiD) {
      ServiceHelpRequest.initiateHelpRequest(
          uiD,
          myLocation.longitude.toStringAsPrecision(10),
          myLocation.latitude.toStringAsPrecision(10),
          event.serviceProviders,
          event.name,
          openTrackingPage,
          witnessDetails);  
    });
  }

  void openTrackingPage(
      //http.Response response, 
      String response,
      List<ServiceProvider> serviceProviders) {
    try {
      if(response != null){
      //if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response);
        if (decodedResponse["status"] == true) {
          getPendingHelpRequestFromServer();
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
      showDataConnectionError(context, wsTechnicalError + ": " + e.toString());
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
