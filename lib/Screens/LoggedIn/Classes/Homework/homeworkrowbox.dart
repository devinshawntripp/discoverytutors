import 'dart:io';

import 'package:disc_t/CustomShapes/customline.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeworkRowBox extends StatefulWidget {
  final dynamic homenotetest;
  HomeworkRowBox({Key key, this.homenotetest}) : super(key: key);

  @override
  _HomeworkRowBoxState createState() => _HomeworkRowBoxState();
}

class _HomeworkRowBoxState extends State<HomeworkRowBox> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(top: 5),
      color: Colors.blue,
      child: Column(children: <Widget>[
        Container(
            width: w,
            child: CustomPaint(
              painter: LinePainter(),
            )),
        Container(
          height: h / 13,
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.archive),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Container(
                  width: w / 3,
                  child: Text(widget.homenotetest.filename ?? '')),
              Container(
                height: 100,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 5,
                      child: Icon(Icons.arrow_drop_up),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 5,
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
              // Icon(Icons.arrow_drop_up),
              Text((widget.homenotetest.upvotes - widget.homenotetest.downvotes)
                      .toString() ??
                  "0"),
              // Icon(Icons.arrow_drop_down),
              // Text(widget.homenotetest.downvotes.toString() ?? 0),
              Text(" Rank: ${widget.homenotetest.rank.toString() ?? ''}"),
            ],
          ),
        ),
        Container(
            width: w,
            child: CustomPaint(
              painter: LinePainter(),
            ))
      ]),
    );
  }
}
