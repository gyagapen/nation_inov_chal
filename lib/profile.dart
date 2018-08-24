import 'package:flutter/material.dart';
import 'drawer.dart';
import 'helpers/constants.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> _bloodGroups = ['A', 'B', 'AB', '0'];
  String _selectedBloodGroup = bloodGroup;

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

    //photo
    var avatarCircle = new Center(
      child: new CircleAvatar(
        backgroundImage: new AssetImage('images/black_avatar.png'),
        backgroundColor: Colors.white,
        radius: 50.0,
      ),
    );

    //name
    var nameHeader = new Container(
      margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      padding: new EdgeInsets.all(5.0),
      height: 150.0,
      color: Colors.grey[300],
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          avatarCircle,
          new Text(
            'Click on the photo to change it',
            style: new TextStyle(fontStyle: FontStyle.italic),
          )
        ],
      ),
    );

    var bloodDropDown = DropdownButton(
      items: _bloodGroups.map((String val) {
        return new DropdownMenuItem<String>(
          value: val,
          child: new Text(val),
        );
      }).toList(),
      value: _selectedBloodGroup,
      onChanged: (newValue) {
        setState(() {
          _selectedBloodGroup = newValue;
        });
      },
    );

    Widget generateTextField(String value, String hintText) {
      var controller = new TextEditingController(text: value);

      var nameInput = new TextField(
        decoration: InputDecoration(hintText: hintText),
        controller: controller,
      );

      return new Expanded(child: nameInput);
    }

    Row generateSettingsRow(Widget item1, Widget item2) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
            width: 150.0,
            child: item1,
          ),
          new Container(
            child: item2,
          ),
        ],
      );
    }

    var saveButton = new Container(
      margin: new EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: new RaisedButton(
        textColor: Colors.red[500],
        child: new Text("Save"),
        onPressed: () {},
      ),
    );

    var formContainer = new Container(
      margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          generateSettingsRow(generateFormLabel("Name"),
              generateTextField(customerName, "Specify your name")),
          generateSettingsRow(generateFormLabel("ID Card No"),
              generateTextField(nic, "Specify your NIC")),
          generateSettingsRow(generateFormLabel("Age"),
              generateTextField(age, "Specify your age")),
          generateSettingsRow(generateFormLabel("Blood Group"), bloodDropDown),
          generateSettingsRow(
              generateFormLabel("Special Conditions"),
              generateTextField(
                  specialConditions, "Specify any special conditions")),
          saveButton,
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Profile"),
      ),
      body: new ListView(
        reverse: true,
        children: [
          new Container(
            margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 100.0),
            child: new Column(
              children: [
                nameHeader,
                formContainer,
              ],
            ),
          )
        ],
      ),
      drawer: buildDrawer(context),
    );
  }
}
