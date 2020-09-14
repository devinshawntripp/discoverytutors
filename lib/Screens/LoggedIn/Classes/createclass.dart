import 'package:flutter/material.dart';

class CreateClass extends StatefulWidget {
  CreateClass({Key key}) : super(key: key);

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff3DDC97),
        appBar: AppBar(
          backgroundColor: Color(0xff7211E0),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          //create messaging for tutors
          title: Text("Create Class"),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            TextField(decoration: InputDecoration(hintText: "Class ID")),
            TextField(decoration: InputDecoration(hintText: "Class Title")),
            TextField(
                decoration: InputDecoration(hintText: "Class Description")),
          ],
        )));
  }
}
