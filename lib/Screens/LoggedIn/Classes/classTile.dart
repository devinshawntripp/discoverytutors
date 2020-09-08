import 'package:disc_t/models/user.dart';
import 'package:flutter/material.dart';

class ClassTile extends StatefulWidget {
  String classname;
  String description;
  String classcode;
  ClassTile({this.classname, this.description, this.classcode});

  @override
  _ClassTileState createState() => _ClassTileState();
}

class _ClassTileState extends State<ClassTile> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      // padding: EdgeInsets.fromLTRB(w / 8, w / 8, w / 8, w / 8),
      margin: EdgeInsets.symmetric(horizontal: w / 36),
      // width: double.infinity,
      // height: double.infinity,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          color: Colors.green[50],
          // elevation: 10,
          // shape:
          // RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          // shape: BorderRadius.all(Radius.circular(30)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  widget.classname ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, height: 2),
                ),
              ),
              // SizedBox(
              //   height: h / 16,
              // ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                      )),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: w,
                height: 30,
                child: Text(
                  widget.classcode ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, height: 1.5),
                ),
                color: Colors.green,
              )
            ],
          ),
        ),
      ),
    );
  }
}
