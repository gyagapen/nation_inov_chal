import 'package:flutter/material.dart';
import 'drawer.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _firstAiderIsEnabled = true;

  @override
  Widget build(BuildContext context) {

    //generate text
    Widget generateFormLabel(String labelContent) {
      return new Container(
        child: Text(
          labelContent,
          style: new TextStyle(fontSize: 17.0),
        ),
      );
    }

    var firstAiderItem = new Checkbox(
      value: _firstAiderIsEnabled,
      onChanged: (newValue) {
        _firstAiderIsEnabled = true;
      },
    );

    //circle switch
    var switchCircle = new Switch(
      value: true,
      onChanged: (newValue) {},
    );

    //insurance switch health
    var swicthInsuranceHealth = new Switch(
      value: false,
      onChanged: (newValue) {},
    );

    //insurance switch health
    var swicthInsuranceCar = new Switch(
      value: false,
      onChanged: (newValue) {},
    );

    //Private Doc
    var switchPrivateDoc = new Switch(
      value: false,
      onChanged: (newValue) {},
    );

    //Send Picture
    var switchSendPicture = new Switch(
      value: false,
      onChanged: (newValue) {},
    );

    //premium slider
    var sliderPremium = new Container(
      decoration: new BoxDecoration(color: Colors.red[500]),
      padding: new EdgeInsets.all(1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new Container(
            child: new RaisedButton(
              color: Colors.white,
              child: new Text("Free"),
              onPressed: () {},
            ),
          ),
          new Container(
            child: new RaisedButton(
              color: Colors.red[500],
              highlightColor: Colors.red,
              child: new Text(
                "Premium",
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );

    Row generateSettingsRow(Widget item1, Widget item2) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
            width: 250.0,
            child: item1,
          ),
          new Container(
            child: item2,
          ),
        ],
      );
    }

    var formContainer = new Container(
      margin: new EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 125.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          generateSettingsRow(
              generateFormLabel("Notify First Aider"), firstAiderItem),
          generateSettingsRow(generateFormLabel("Notify Circle"), switchCircle),
          generateSettingsRow(generateFormLabel("Notify Insurance - Health"),
              swicthInsuranceHealth),
          generateSettingsRow(
              generateFormLabel("Notify Insurance - Car"), swicthInsuranceCar),
          generateSettingsRow(
              generateFormLabel("Notify Private Doctor"), switchPrivateDoc),
          generateSettingsRow(generateFormLabel("Send picture in case of events"),
              switchSendPicture),
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new Column(
        children: [formContainer, sliderPremium],
      ),
      drawer: buildDrawer(context),
    );
  }
}
