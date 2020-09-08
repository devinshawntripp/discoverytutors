import 'package:disc_t/Screens/RegisterDecider/classlist.dart';
import 'package:flutter/material.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/Screens/RegisterDecider/registerTutor.dart';

class UserTutorTile extends StatefulWidget {
  final String classname;
  UserTutorTile({this.classname});
  @override
  _ClassTileState createState() => _ClassTileState();
}

class _ClassTileState extends State<UserTutorTile> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
          child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 200,
          height: 65,
          child: Card(
              elevation: 20,
              // margin: EdgeInsets.fromLTRB(20.0, 3.0, 5.0, 3.0),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                leading: Icon(Icons.assignment),
                title: Text(
                  widget.classname,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(new Radius.circular(30))),
              color: Color(0xff46237A)),
        ),
      )),
    );
  }
}
