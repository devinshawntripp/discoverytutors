import 'package:disc_t/models/user.dart';
import 'package:flutter/material.dart';

//this class will show the homework, notes, and tests data
class UserClassPage extends StatefulWidget {
  UserClassData data;

  UserClassPage({Key key, this.data}) : super(key: key);

  @override
  _ClassPageState createState() => _ClassPageState();
}

class _ClassPageState extends State<UserClassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff7211E0),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.data.documentID),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text("Prequisites"),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.data.preq.length,
                    itemBuilder: (context, index) {
                      return Text(
                        widget.data.preq[index].classname,
                        style: TextStyle(color: Colors.red),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
