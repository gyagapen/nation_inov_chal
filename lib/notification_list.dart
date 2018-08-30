import 'package:flutter/material.dart';
import 'angel_notif_info.dart';

class NotificationListPage extends StatefulWidget {
  NotificationListPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _NotificationListPageState createState() => new _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  Widget build(BuildContext context) {
    var title = new Center(
      child: new Text("My notifications"),
    );

    var notifList = new ListView(
      children: [
        new ListTile(
          title: new Row(
            children: [
              new Text("Angel's notification : Health",
                  style: new TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          leading: new ImageIcon(new AssetImage("images/health.png")),
          subtitle: new Container(
            padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: Text("Guillaume Yagapen has got an Health issue"),
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.arrow_forward_ios),
            onPressed: () {
              //open notification details
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new AngelNotifInfoPage(),
                ),
              );
            },
          ),
        ),
        new Divider(),
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("My Notifications"),
      ),
      body: new Container(
        padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: notifList,
      ),
    );
  }
}
