import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';
import 'drawer.dart';
import 'insert_circle.dart';
import 'models/circle_model.dart';
import 'services/service_help_request.dart';
import 'dialogs/dialog_error_webservice.dart';
import 'helpers/common.dart';
import 'dart:convert';
import 'dialogs/delete_circle_dialog.dart';
import 'update_circle.dart';

class CirclePage extends StatefulWidget {
  CirclePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CirclePageState createState() => new _CirclePageState();
}

class _CirclePageState extends State<CirclePage> {
  ProgressHUD _progressHUD;
  List<CircleModel> _circlesList = new List<CircleModel>();

  void initState() {
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

    populateCircleList();
  }

  //build main widget
  Widget build(BuildContext context) {
    if (refreshCircleList) {
      populateCircleList();
      refreshCircleList = false;
    }

    //generate contact list tile
    ListTile generateContactListTile(CircleModel circleModel, String photo) {
      var avatarCircle = new CircleAvatar(
        backgroundImage: new AssetImage(photo),
        radius: 20.0,
      );

      return new ListTile(
        title: new Text(circleModel.name),
        subtitle: new Text(circleModel.number),
        leading: avatarCircle,
        trailing: new Column(
          children: [
            new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new UpdateCirclePage(
                          circleModel: circleModel,
                        ),
                  ),
                );
              },
            ),
            new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                showDeleteCircleDialog(context, circleModel.id, deleteCircle);
              },
            ),
          ],
        ),
      );
    }

    ListView generateContactList() {
      List<Widget> listTiles = new List<Widget>();

      for (var circle in _circlesList) {
        if (circle != null) {
          listTiles.add(
              generateContactListTile(circle, 'images/anonymous_avatar.png'));
          listTiles.add(new Divider());
        }
      }

      return new ListView(
        children: listTiles,
      );
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text("My Circle")),
      body: generateContactList(),
      //body: snackBar,
      drawer: buildDrawer(context),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new InsertCirclePage(),
            ),
          );
        },
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //populate list of circle modes
  void populateCircleList() {
    //show loading progress
    if ((_progressHUD.state != null)) {
      _progressHUD.state.show();
    }

    //submit to server
    ServiceHelpRequest.getCircles(storedUiD).then((response) {
      //dismiss loading dialog
      if ((_progressHUD.state != null)) {
        _progressHUD.state.dismiss();
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        if (decodedResponse["status"] == true) {
          //map with object
          List<CircleModel> wsCircles = new List<CircleModel>();
          for (var circle in decodedResponse["circles"]) {
            wsCircles.add(CircleModel.fromJson(circle));
          }

          setState(() {
            _circlesList = wsCircles;
          });
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
      showDataConnectionError(context, wsTechnicalError + ": " + e.toString());
    });
  }

  //populate list of circle modes
  void deleteCircle(String id) {
    //show loading progress
    if ((_progressHUD.state != null)) {
      _progressHUD.state.show();
    }

    //submit to server
    ServiceHelpRequest.deleteCircle(id).then((response) {
      //dismiss loading dialog
      if ((_progressHUD.state != null)) {
        _progressHUD.state.dismiss();
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        if (decodedResponse["status"] == true) {
          //delete ok - refresh circles
          setState(() {
            refreshCircleList = true;
          });
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
      showDataConnectionError(context, wsTechnicalError + ": " + e.toString());
    });
  }
}
