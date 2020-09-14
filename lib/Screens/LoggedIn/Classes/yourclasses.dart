import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/classlist.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/pickfromallclasses.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/userclasslist.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
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
    // Provider.of<ClassDataNotifier>(context, listen: false).getTheClasses();
    // ClassDataNotifier classdatanotif =
    //     Provider.of<ClassDataNotifier>(context, listen: false);

    var u = FirebaseAuth.instance.currentUser();
    // final user = Provider.of<User>(context);
    // print(user.uid);

    u.then((value) {
      print(value.uid);
      Provider.of<UserDataNotifier>(context, listen: false)
          .getTheUser(value.uid);
      Provider.of<ClassDataNotifier>(context, listen: false)
          .getTheUser(value.uid);
    });

    Provider.of<UserDataNotifier>(context, listen: false).getTheUserClasses();
    super.initState();
  }

  _refresh() async {
    setState(() {
      Provider.of<UserDataNotifier>(context, listen: false).getTheUserClasses();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    // ClassDataNotifier classData = Provider.of<ClassDataNotifier>(context);
    // List<UserClassData> cData = Provider.of<List<UserClassData>>(context);
    // final d = context.watch<ClassDataNotifier>();
    final d = context.watch<ClassDataNotifier>();

    final userdata = context.watch<UserDataNotifier>();
    // List<ClassData> classl = Provider.of<List<ClassData>>(context);
    final user = Provider.of<User>(context);

    UserData data = Provider.of<UserData>(context);

    double h = MediaQuery.of(context).size.height;

    // print(data);
    return Scaffold(
      backgroundColor: Color(0xff3DDC97),
      appBar: AppBar(
        backgroundColor: Color(0xff7211E0),
        title: userdata.user == null
            ? CircularProgressIndicator()
            : Text(userdata.user.firstName ?? ""),
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
                          data: userdata.classes,
                          dataNotif: d,
                        )),
              RaisedButton(
                child: Text("Add Class"),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PickFromAllClasses()))
                      .then((value) {
                    // print(value);
                    if (value == 'success') {
                      // print("DLKJFDKLFJ");
                      print(value);
                      setState(() {
                        d.getTheClasses();
                        userdata.getTheUser(user.uid);
                        userdata.getTheUserClasses();
                        Provider.of<UserDataNotifier>(context, listen: false)
                            .getTheUserClasses();
                      });
                    }
                  });
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
