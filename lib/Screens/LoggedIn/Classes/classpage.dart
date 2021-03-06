import 'package:disc_t/Screens/LoggedIn/Classes/tile.dart';
import 'package:disc_t/models/user.dart';
import 'package:flutter/material.dart';

//this class will show the homework, notes, and tests data
class ClassPage extends StatefulWidget {
  ClassData data;

  ClassPage({Key key, this.data}) : super(key: key);

  @override
  _ClassPageState createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Color(0xff3DDC97),
        appBar: AppBar(
          backgroundColor: Color(0xff7211E0),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.data.documentID),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Tile(
                name: "Homework",
                classdata: widget.data,
              ),
              Tile(
                name: "Notes",
                classdata: widget.data,
              ),
              Tile(
                name: "Tests",
                classdata: widget.data,
              ),
              Expanded(
                child: Text(""),
              ),
              widget.data.preq == null
                  ? Text("")
                  : Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              height: h * .04,
                              width: w,
                              child: Text("Prequisites",
                                  textAlign: TextAlign.center)),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 40,
                            width: w,
                            child: widget.data.preq == null
                                ? Text("")
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.data.preq.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Container(
                                            color: Colors.blue,
                                            padding: EdgeInsets.all(5),
                                            child: Center(
                                              child: Text(
                                                widget
                                                    .data.preq[index].classname,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ));
  }
}
