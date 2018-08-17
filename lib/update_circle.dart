import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';
import 'helpers/common.dart';
import 'services/service_help_request.dart';
import 'dart:convert';
import 'drawer.dart';
import 'dialogs/dialog_error_webservice.dart';
import 'models/circle_model.dart';

class UpdateCirclePage extends StatefulWidget {
  UpdateCirclePage({Key key, this.title, this.circleModel}) : super(key: key);

  final String title;
  final CircleModel circleModel;

  @override
  _UpdateCirclePageState createState() => new _UpdateCirclePageState();
}

class _UpdateCirclePageState extends State<UpdateCirclePage> {
  ProgressHUD _progressHUD;
  String _name;
  String _number;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    print("init called");

    super.initState();

    //initiate progress hud
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black54,
      color: Colors.white,
      containerColor: Colors.red[900],
      borderRadius: 5.0,
      text: 'Loading...',
      loading: false,
    );

    _name = this.widget.circleModel.name;
    _number = this.widget.circleModel.number;
  }

  //build main widget
  Widget build(BuildContext context) {
    //photo
    var avatarCircle = new Center(
      child: new CircleAvatar(
        backgroundImage: new AssetImage('images/anonymous_avatar.png'),
        radius: 50.0,
      ),
    );

    //photo band
    var nameHeader = new Container(
      padding: new EdgeInsets.all(5.0),
      height: 150.0,
      color: Colors.grey[300],
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [avatarCircle],
      ),
    );

    var form = new Form(
      key: _formKey,
      child: new Column(
        children: [
          //Name
          new Container(
            margin: new EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 15.0),
            child: new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
              },
              initialValue: this.widget.circleModel.name,
              onSaved: (val) => _name = val,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                hintText: 'Short name of your emergency contact',
                hintStyle: new TextStyle(fontStyle: FontStyle.italic),
                labelText: 'Name',
                labelStyle: new TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          //Number
          new Container(
            margin: new EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 15.0),
            child: new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length > 8) {
                  return 'Maximum of 8 characters allowed';
                }
              },
              initialValue: this.widget.circleModel.number,
              onSaved: (val) => _number = val,
              keyboardType: TextInputType.phone,
              decoration: new InputDecoration(
                hintText: 'Phone number of your emergency contact',
                hintStyle: new TextStyle(fontStyle: FontStyle.italic),
                labelText: 'Mobile number',
                labelStyle: new TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    );

    var actionButtons = new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        new Container(
          margin: new EdgeInsets.fromLTRB(45.0, 5.0, 10.0, 5.0),
          child: new RaisedButton(
            onPressed: () {
              _submitForm();
            },
            color: Colors.green,
            child: new Row(
              children: [
                new Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                new Text(
                  "Save",
                  style: new TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        new Container(
          margin: new EdgeInsets.fromLTRB(5.0, 5.0, 90.0, 5.0),
          child: new RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            child: new Row(
              children: [
                new Icon(
                  Icons.backspace,
                  color: Colors.white,
                ),
                new Text(
                  "Back",
                  style: new TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return new Stack(
      children: [
        new Scaffold(
          appBar: new AppBar(title: new Text("Update Circle")),
          body: new ListView(
            children: [nameHeader, form],
          ),
          drawer: buildDrawer(context),
          persistentFooterButtons: [actionButtons],
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
        _progressHUD
      ],
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      //show loading progress
      if ((_progressHUD.state != null)) {
        _progressHUD.state.show();
      }

      //submit to server
      ServiceHelpRequest
          .updateCircle(this.widget.circleModel.id, _name, _number)
          .then((response) {
        //dismiss loading dialog
        if ((_progressHUD.state != null)) {
          _progressHUD.state.dismiss();
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> decodedResponse = json.decode(response.body);
          if (decodedResponse["status"] == true) {
            //correctly saved
            refreshCircleList = true;
            Navigator.pop(context);
          } else {
            showDataConnectionError(
                context, wsUserError + decodedResponse["error"]);
          }
        }
      }).catchError((e) {
        //dismiss loading dialog
        if ((_progressHUD.state != null)) {
          _progressHUD.state.dismiss();
        }
        showDataConnectionError(
            context, wsTechnicalError + ": " + e.toString());
      });
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}
