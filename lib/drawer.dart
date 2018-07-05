import 'package:flutter/material.dart';
import 'settings.dart';
import 'circle.dart';
import 'profile.dart';

//part of 'main.dart';

Widget buildDrawer(context) {
  var drawer = new Drawer(
      child: new ListView(
    children: [
      new DrawerHeader(
          child: new Column(
        children: [
          //new Text('Menu', style: new TextStyle(fontSize: 20.0),),
          new Image.asset(
            "images/drawer_heartbeat.jpg",
          )
        ],
      )),
      new ListTile(
        title: new Row(
          children: [
            new Container(
              margin: new EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: new Icon(
                Icons.home,
                size: 30.0,
                color: Colors.red[900],
              ),
            ),
            new Text(
              'Home',
              style: new TextStyle(fontSize: 20.0),
            ),
          ],
        ),
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
      ),
      new ListTile(
        title: new Row(
          children: [
            new Container(
              margin: new EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: new Icon(
                Icons.people,
                size: 30.0,
                color: Colors.red[900],
              ),
            ),
            new Text(
              'Circle',
              style: new TextStyle(fontSize: 20.0),
            ),
          ],
        ),
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new CirclePage(),
            ),
          );
        },
      ),
      new Divider(),
      new ListTile(
        title: new Row(
          children: [
            new Container(
              margin: new EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: new Icon(
                Icons.account_circle,
                size: 30.0,
                color: Colors.red[900],
              ),
            ),
            new Text(
              'Profile',
              style: new TextStyle(fontSize: 20.0),
            ),
          ],
        ),
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
          Navigator.push(
            context, 
            new MaterialPageRoute(
              builder: (context) => new ProfilePage(),
            ),
          );
        },
      ),
      new Divider(),
      new ListTile(
        title: new Row(
          children: [
            new Container(
              margin: new EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: new Icon(
                Icons.settings,
                size: 30.0,
                color: Colors.red[900],
              ),
            ),
            new Text(
              'Settings',
              style: new TextStyle(fontSize: 20.0),
            ),
          ],
        ),
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new SettingsPage(),
            ),
          );
        },
      ),
    ],
  ));

  /*return new Column(
    children: [
      new Image.asset(
        "images/drawer_heartbeat.jpg",
        fit: BoxFit.fill,
      ),
      drawer
    ],
  );*/

  return drawer;
}
