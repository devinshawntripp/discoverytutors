import 'package:disc_t/Screens/LoggedIn/TutorsView/usertutortile.dart';
import 'package:flutter/material.dart';

class TutorsClassList extends StatefulWidget {
  final List<String> classes;
  TutorsClassList({this.classes});
  @override
  _TutorsClassListState createState() => _TutorsClassListState();
}

class _TutorsClassListState extends State<TutorsClassList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemExtent: null,
      itemCount: widget.classes.length,
      itemBuilder: (context, index) {
        return UserTutorTile(classname: widget.classes[index]);
      },
    );
  }
}
