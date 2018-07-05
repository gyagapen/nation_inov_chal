import 'package:flutter/material.dart';
import 'dart:async';
import 'drawer.dart';

class CirclePage extends StatefulWidget {
  CirclePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CirclePageState createState() => new _CirclePageState();
}

class _CirclePageState extends State<CirclePage> {
  void initState() {
    print("init called");

    super.initState();
  }

  //build main widget
  Widget build(BuildContext context) {
    //generate contact list tile
    ListTile generateContactListTile(String name, String tel, String photo) {
      var avatarCircle = new Center(
        child: new CircleAvatar(
          backgroundImage: new AssetImage(photo),
          radius: 20.0,
        ),
      );

      return new ListTile(
        title: new Text(name),
        subtitle: new Text(tel),
        leading: avatarCircle,
        trailing: new Row(
          children: [new Icon(Icons.edit), new Icon(Icons.delete)],
        ),
      );
    }

    ListView generateContactList() {
      return new ListView(
        children: [
          generateContactListTile("Dad", "59807708", 'images/pic_avatar.jpg'),
          generateContactListTile("Mum", "59632585", 'images/pic_avatar.jpg'),
          generateContactListTile(
              "Sister", "57485656", 'images/pic_avatar.jpg'),
          generateContactListTile(
              "Brother", "54215858", 'images/pic_avatar.jpg'),
        ],
      );
    }


    return new Scaffold(
      appBar: new AppBar(title: new Text("My Circle")),
      body: generateContactList(),
      //body: snackBar,
      drawer: buildDrawer(context),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
