import 'package:disc_t/Screens/LoggedIn/Classes/pickfromallclasses.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/userclasslist.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourClasses extends StatefulWidget {
  Tutor userdata;
  YourClasses({this.userdata});

  @override
  _YourClassesState createState() => _YourClassesState();
}

class _YourClassesState extends State<YourClasses> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Tutor userdata = Provider.of<Tutor>(context);

    double h = MediaQuery.of(context).size.height;

    List<ClassData> classd = Provider.of<List<ClassData>>(context);
    // return Text("");

    List<ClassData> userClasses =
        classd.where((element) => (element.picked == true)).toList();

    return classd == null
        ? Loading()
        : userClasses == null
            ? Loading()
            : Scaffold(
                backgroundColor: Color(0xff3DDC97),
                appBar: AppBar(
                  backgroundColor: Color(0xff7211E0),
                  title: widget.userdata == null
                      ? CircularProgressIndicator()
                      : Text(widget.userdata.firstName ?? ""),
                ),
                body: Container(
                    // padding: EdgeInsets.symmetric(vertical: h / 8),
                    padding: EdgeInsets.fromLTRB(0, h / 8, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                            height: h * .5,
                            child: widget.userdata.classes == null
                                ? Loading()
                                : UserClassList(
                                    data: userClasses,
                                  )),
                        RaisedButton(
                          child: Text("Add Class"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PickFromAllClasses(
                                          classl: classd,
                                        )));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.blue,
                        )
                      ],
                    )),
              );
  }
}
