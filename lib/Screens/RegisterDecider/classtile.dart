import 'package:flutter/material.dart';
import 'package:disc_t/models/user.dart';

class ClassTile extends StatefulWidget {
  final ClassData classPassed;
  ClassTile({this.classPassed});
  @override
  _ClassTileState createState() => _ClassTileState();
}

class _ClassTileState extends State<ClassTile> {
  int selectedColor = 0xff256EFF;

  toggleColor() {
    if (selectedColor == 0xff256EFF) {
      selectedColor = 0xff3DDC97;
    } else {
      selectedColor = 0xff256EFF;
    }
  }

  addclass(String name) {
    if (selectedColor == 0xff256EFF) {
      takenClasses.remove(name);
    } else {
      takenClasses.add(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              child: Card(
                margin: EdgeInsets.fromLTRB(20.0, 3.0, 5.0, 3.0),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ListTile(
                    onTap: (() {
                      setState(() {
                        toggleColor();
                        addclass(widget.classPassed.classid);
                      });

                      // for (var some in takenClasses) {
                      //   print("some class added" + some);
                      // }

                      // print(selectedColor);

                      // print(widget.classPassed.classid + " Tapped");
                    }),
                    contentPadding: EdgeInsets.only(left: 5),
                    leading: Icon(Icons.assignment),
                    title: Text(
                      widget.classPassed.classid,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(new Radius.circular(30))),
                color: Color(selectedColor),
                elevation: 15,
              ),
            ),
          )),
    );
  }
}
