import 'package:flutter/material.dart';
import 'animations/animated_spcard.dart';
import 'animations/animated_color_icon.dart';
import 'helpers/common.dart';
import 'helpers/mapview.dart';
import 'dialogs/cancel_sprequest_dialog.dart';
import 'models/service_provider.dart';
import 'models/help_request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dialogs/dialog_error_webservice.dart';
import 'package:progress_hud/progress_hud.dart';
import 'services/service_help_request.dart';

class TrackingPage extends StatefulWidget {
  TrackingPage({Key key, this.serviceProviders, this.helpRequest})
      : super(key: key);

  final List<ServiceProvider> serviceProviders;
  final HelpRequest helpRequest;
  _TrackingPageState createState() => new _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  //animated text components
  AnimationController controllerText;
  Animation<double> animationText;

  //animated icon components
  AnimationController controllerIcon;
  Animation<double> animationIcon;

  TrackingMap trackingMap;
  List<Widget> spCards;
  ListView mainColumn;

  ProgressHUD _progressHUD;

//initialise animation
  initState() {
    super.initState();

    //initiate animated text
    initiateAnimationComponents();

    WidgetsBinding.instance.addObserver(this);

    //contact each service provider
    for (var sp in widget.serviceProviders) {
      if (!sp.isOptional) {
        UpdateServiceProviderStatus(sp, receiveServiceProviderStatusUpdate);
      }
    }

    //initiate progress hud
    _progressHUD = new ProgressHUD(
        backgroundColor: Colors.black54,
        color: Colors.white,
        containerColor: Colors.red[900],
        borderRadius: 5.0,
        text: 'Loading...');
  }

  Widget build(BuildContext context) {
    void openTrackingGpsMap() {
      //show map
      trackingMap =
          new TrackingMap(widget.serviceProviders, widget.helpRequest, context);
      trackingMap.showMap();
    }

    Widget generateSpCard(ServiceProvider serviceProvider) {
      var spNameHeader = new Container(
          padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 25.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              new Container(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                child: AnimatedColorIcon(
                  animation: animationIcon,
                  iconImage: serviceProvider.iconInfo.iconImage,
                  color1: serviceProvider.iconInfo.highlightColor1,
                  color2: serviceProvider.iconInfo.highlightColor2,
                ),
              ),
              new Text(
                serviceProvider.name.toUpperCase(),
                style: new TextStyle(
                  fontSize: 25.0,
                ),
              )
            ],
          ));

      var spCard = AnimatedSpCard(
          animation: animationText,
          serviceProvider: serviceProvider,
          header: spNameHeader);

      return spCard;
    }

    List<Widget> buildListOfSpCards() {
      spCards = new List<Widget>();

      for (var sp in widget.serviceProviders) {
        if (!sp.isOptional) {
          spCards.add(generateSpCard(sp));
        } else {
          //if optional, provide option to call service provider
          spCards.add(new Container(
            child: new FlatButton(
              textColor: Colors.red,
              child: new Text("Click here to call " + sp.name),
              onPressed: () {
                setState(() {
                  UpdateServiceProviderStatus(
                      sp, receiveServiceProviderStatusUpdate);
                  sp.isOptional = false;
                });
              },
            ),
          ));
        }
      }

      return spCards;
    }

    var actionButtons = new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        new Container(
          padding: new EdgeInsets.fromLTRB(75.0, 5.0, 20.0, 5.0),
          child: new RaisedButton(
            textColor: Colors.black,
            child: new Text("Track".toUpperCase()),
            onPressed: trackingButtonIsEnabled() ? openTrackingGpsMap : null,
          ),
        ),
        new Container(
          padding: new EdgeInsets.fromLTRB(5.0, 5.0, 75.0, 5.0),
          child: new RaisedButton(
            disabledColor: Colors.black,
            child: new Text("Cancel".toUpperCase()),
            onPressed: () {
              showCancelSPRequestDialog(context, callCancelHelpRequestWs);
            },
          ),
        ),
      ],
    );

    //initialise main column
    mainColumn = ListView(
      children: buildListOfSpCards(),
    );

    return new Scaffold(
      appBar: new AppBar(title: appTitleBar),
      body: new Center(
        child: new Container(
            margin: new EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 5.0),
            child: mainColumn),
      ),
      persistentFooterButtons: [actionButtons],
    );
  }

  //********************* functions **********************//

  void initiateAnimationComponents() {
    //text animation
    controllerText = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animationText = new Tween(begin: 0.0, end: 100.0).animate(controllerText);

    animationText.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerText.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controllerText.forward();
      }
    });

    controllerText.forward();

    //icon animation
    controllerIcon = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animationIcon = new Tween(begin: 0.0, end: 100.0).animate(controllerText);

    animationIcon.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerIcon.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controllerIcon.forward();
      }
    });

    controllerIcon.forward();
  }

  void receiveServiceProviderStatusUpdate(ServiceProvider newSp) {
    setState(() {
      //update status and uid
      for (var sp in widget.serviceProviders) {
        if (sp.name == newSp.name) {
          setState(() {
            sp.uid = newSp.uid;
            sp.status = newSp.status;
          });
        }
      }
    });
  }

  bool trackingButtonIsEnabled() {
    bool trackingButtonEnabled = false;

    for (var sp in widget.serviceProviders) {
      if ((sp.name != "Police") && (sp.status.value == 1)) {
        trackingButtonEnabled = true;
      }
    }

    return trackingButtonEnabled;
  }

  //call web service to perform cancellation of help request
  void callCancelHelpRequestWs() {
    if (_progressHUD != null) {
      //_progressHUD.state.show();
    }

    ServiceHelpRequest.cancelHelpReauest(
        widget.helpRequest.id, cancelWsCallback);
  }

  void cancelWsCallback(http.Response response) {
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        if (decodedResponse["status"] == true) {
          //pop back
          Navigator.popUntil(context, ModalRoute.withName('/'));
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

    /*if (_progressHUD != null) {
      _progressHUD.state.dismiss();
    }*/
  }

  /****** Handle activity states **********/

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state has changed: " + state.toString());
    setState(() {
      if (state == AppLifecycleState.resumed) {
        if (trackingMap != null) {
          trackingMap.handleDismiss();
        }
      }
    });
  }
}
