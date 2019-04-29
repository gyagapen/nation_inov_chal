import 'package:flutter/material.dart';

class MyStepperPage extends StatefulWidget {
  MyStepperPage({Key key}) : super(key: key);
  @override
  _MyStepperPageState createState() => new _MyStepperPageState();
}

class _MyStepperPageState extends State<MyStepperPage> {

  int _currentstep = 0;
  void _movetonext() {
    setState(() {      
      _currentstep++;
    });
  }

  void _movetostart() {
     setState(() {
      _currentstep = 0;
    });
  }

  void _showcontent(int s) {
    showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('You clicked on'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              spr[s].title,
              spr[s].subtitle,
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return 
            new Stepper(steps: spr, type: StepperType.vertical, currentStep: _currentstep, onStepContinue: _movetonext, onStepCancel: _movetostart, 
            onStepTapped: _showcontent,);
  }
}

const List<Step> spr = <Step>[
 // const Step( title:  ,'SubTitle1', 'This is Content', state: StepState.indexed, true)
    Step(title: const Text('Hello1'), subtitle: Text('SubTitle1'), content: const Text('This is Content1'), state: StepState.indexed, isActive: true),
    Step(title: const Text('Hello2'), subtitle: Text('SubTitle2'), content: const Text('This is Content2'), state: StepState.indexed, isActive: true),
    Step(title: const Text('Hello3'), subtitle: Text('SubTitle3'), content: const Text('This is Content3'), state: StepState.indexed, isActive: true),
    Step(title: const Text('Hello4'), subtitle: Text('SubTitle4'), content: const Text('This is Content4'), state: StepState.indexed, isActive: true),
    Step(title: const Text('Hello5'), subtitle: Text('SubTitle5'), content: const Text('This is Content5'), state: StepState.indexed, isActive: true),
    Step(title: const Text('Hello6'), subtitle: Text('SubTitle6'), content: const Text('This is Content6'), state: StepState.indexed, isActive: true),
    Step(title: const Text('Hello7'), subtitle: Text('SubTitle7'), content: const Text('This is Content7'), state: StepState.indexed, isActive: true),
    Step(title: const Text('Hello8'), subtitle: Text('SubTitle8'), content: const Text('This is Content8'), state: StepState.indexed, isActive: true),
    Step(title: const Text('Hello9'), subtitle: Text('SubTitle9'), content: const Text('This is Content9'), state: StepState.indexed, isActive: true),
    Step(title: const Text('Hello10'), subtitle: Text('SubTitle10'), content: const Text('This is Content10'), state: StepState.indexed, isActive: true),
  ];
