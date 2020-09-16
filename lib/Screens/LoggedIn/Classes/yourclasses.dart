import 'package:disc_t/Screens/LoggedIn/Classes/pickfromallclasses.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/userclasslist.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourClasses extends StatefulWidget {
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
    Tutor userdata = Provider.of<Tutor>(context);

    double h = MediaQuery.of(context).size.height;

    List<ClassData> classd = Provider.of<List<ClassData>>(context);

    List<ClassData> userClasses =
        classd.where((element) => (element.picked == true)).toList();

    return userClasses == null
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xff3DDC97),
            appBar: AppBar(
              backgroundColor: Color(0xff7211E0),
              title: userdata == null
                  ? CircularProgressIndicator()
                  : Text(userdata.firstName ?? ""),
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
                        child: userdata.classes == null
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
                                builder: (context) => PickFromAllClasses()));
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
