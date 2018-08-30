import 'package:flutter/material.dart';
import 'helpers/common.dart';
import 'package:url_launcher/url_launcher.dart';

class AngelNotifInfoPage extends StatefulWidget {
  AngelNotifInfoPage({Key key}) : super(key: key);

  @override
  _AngelNotifInfoPageState createState() => new _AngelNotifInfoPageState();
}

class _AngelNotifInfoPageState extends State<AngelNotifInfoPage>
    with WidgetsBindingObserver {
  @override
  initState() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var actionButtons = [
      new Container(
        padding: new EdgeInsets.fromLTRB(2.0, 5.0, 5.0, 5.0),
        child: new RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.black,
          child: new Row(
            children: [
              new Icon(Icons.navigation),
              new Text("Go".toUpperCase()),
            ],
          ),
          onPressed: () {
            String url =
                'https://www.google.com/maps/dir/?api=1&destination=-19.9993787,57.5847775&dir_action=navigate';
            launch(url);
          },
        ),
      ),
      new Container(
        padding: new EdgeInsets.fromLTRB(10.0, 0.0, 85.0, 5.0),
        child: new RaisedButton(
          color: Colors.green,
          textColor: Colors.white,
          disabledColor: Colors.black,
          child: new Row(
            children: [
              new Icon(Icons.call),
              new Text("CALL".toUpperCase()),
            ],
          ),
          onPressed: () {
            String url = 'tel:59807708';
            launch(url);
          },
        ),
      ),
    ];

    var mainWrapper = new Column(
      children: [
        buildHelpRequestCard(),
      ],
    );

    return new Scaffold(
        appBar: new AppBar(
          title: getAppTitleBar(context),
        ),
        body: new Stack(children: [mainWrapper]),
        persistentFooterButtons: actionButtons
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Card buildHelpRequestCard() {
    //build help request cards

    var spNameHeader = new Container(
        padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            new Container(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
              child: new ImageIcon(new AssetImage("images/health.png")),
            ),
            new Text(
              "HEALTH",
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ],
        ));

    var spGeneralInfoContent = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        new Column(
          children: [
            //Title
            new Center(
              child: new Container(
                padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: new Text(
                  "General Info",
                  style: new TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            //Name
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                new Container(
                    padding: new EdgeInsets.fromLTRB(40.0, 10.0, 25.0, 0.0),
                    child: new Text(
                      "Name: ",
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    )),
                new Container(
                    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: new Text(
                      "Guillaume Yagapen",
                      style: new TextStyle(color: Colors.black, fontSize: 15.0),
                    )),
              ],
            ),
            //NIC
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                new Container(
                    padding: new EdgeInsets.fromLTRB(40.0, 10.0, 25.0, 0.0),
                    child: new Text(
                      "ID No: ",
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    )),
                new Container(
                    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: new Text(
                      "Y050989223890F",
                      style: new TextStyle(color: Colors.black, fontSize: 15.0),
                    )),
              ],
            ),
            //Age
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                new Container(
                    padding: new EdgeInsets.fromLTRB(40.0, 10.0, 35.0, 0.0),
                    child: new Text(
                      "Age: ",
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    )),
                new Container(
                    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: new Text(
                      "30",
                      style: new TextStyle(color: Colors.black, fontSize: 15.0),
                    )),
              ],
            ),
            //Blood group
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                new Container(
                    padding: new EdgeInsets.fromLTRB(40.0, 10.0, 60.0, 0.0),
                    child: new Text(
                      "Blood group: ",
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    )),
                new Container(
                    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: new Text(
                      "O",
                      style: new TextStyle(color: Colors.black, fontSize: 15.0),
                    )),
              ],
            ),
            //Special conditions
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                new Container(
                    padding: new EdgeInsets.fromLTRB(40.0, 10.0, 15.0, 10.0),
                    child: new Text(
                      "Special Conditions: ",
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    )),
                new Container(
                    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: new Text(
                      "Cardiac",
                      style: new TextStyle(color: Colors.black, fontSize: 15.0),
                    )),
              ],
            ),
          ],
        ),
      ],
    );

    var spLocationContent = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new Column(children: [
            //Title
            new Center(
              child: new Container(
                padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                child: new Text(
                  "Location Info",
                  style: new TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ]),
          //Address
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              new Container(
                padding: new EdgeInsets.fromLTRB(40.0, 0.0, 10.0, 0.0),
                child: new Text(
                  "Address: ",
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              new Flexible(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Ave Des Rossignoles, Pereybere, Grand Baie",
                      style: new TextStyle(color: Colors.black, fontSize: 15.0),
                    )
                  ],
                ),
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              new Container(
                padding: new EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                child: new Row(children: [
                  new Icon(Icons.hourglass_empty),
                  new Text(
                    "47 min",
                    style: new TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 15.0),
                  ),
                ]),
              ),
              new Container(
                  padding: new EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                  child: new Row(
                    children: [
                      new Icon(Icons.drive_eta),
                      new Text(
                        "52 km",
                        style: new TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 15.0),
                      ),
                    ],
                  ))
            ],
          )
        ]);

    var spCard = new Card(
        margin: new EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: new Container(
          width: 350.0,
          height: 450.0,
          child: new Column(children: [
            spNameHeader,
            new Divider(
              color: Colors.black45,
            ),
            spGeneralInfoContent,
            new Divider(
              color: Colors.black45,
            ),
            spLocationContent
          ]),
        ));

    return spCard;
  }

  /****** Handle activity states **********/

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {}
}
