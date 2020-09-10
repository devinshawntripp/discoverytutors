import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/classlist.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/userclasslist.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:disc_t/Services/database.dart';
// import 'package:image_picker/image_picker.dart';

class YourClasses extends StatefulWidget {
  @override
  _YourClassesState createState() => _YourClassesState();
}

class _YourClassesState extends State<YourClasses> {
  //const YourClasses({Key key}) : super(key: key);

  // Future<dynamic> getClasses(userid) async {}

  @override
  void initState() {
    // ClassDataNotifier classdatanotif =
    //     Provider.of<ClassDataNotifier>(context, listen: false);
    var u = FirebaseAuth.instance.currentUser();
    // final user = Provider.of<User>(context);
    // print(user.uid);

    u.then((value) {
      print(value.uid);
      Provider.of<UserDataNotifier>(context, listen: false)
          .getTheUser(value.uid);
    });

    Provider.of<UserDataNotifier>(context, listen: false).getTheUserClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    // ClassDataNotifier classData = Provider.of<ClassDataNotifier>(context);
    // List<UserClassData> cData = Provider.of<List<UserClassData>>(context);

    final userdata = context.watch<UserDataNotifier>();

    double h = MediaQuery.of(context).size.height;

    // print(data);
    return Scaffold(
      backgroundColor: Color(0xff3DDC97),
      appBar: AppBar(
        backgroundColor: Color(0xff7211E0),

        title: userdata.user == null
            ? CircularProgressIndicator()
            : Text(userdata.user.firstName ?? ""),
        // title: StreamBuilder(
        //   stream: Firestore.instance
        //       .collection("Tutors")
        //       .document(user.uid)
        //       .snapshots(),
        //   builder: (context, snapshot) {
        //     return Text(snapshot.data["firstname"] ?? "");
        //   },
        // ),
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
                      : userdata.classes.isEmpty
                          ? Loading()
                          : UserClassList(
                              data: userdata.classes,
                            )),
              RaisedButton(
                child: Text("Add Class"),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.blue,
              )
            ],
          )),
    );
  }
}
