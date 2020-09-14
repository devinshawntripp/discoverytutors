import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/createclass.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/pickfromallclasses.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/yourclasses.dart';
import 'package:disc_t/Screens/LoggedIn/TutorsView/userprofile.dart';
import 'package:disc_t/Services/auth.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tutorslist.dart';
import '../Classes/allclasses.dart';

//widget shows all of the tutors using the app

class Tutors extends StatefulWidget {
  @override
  _TutorsState createState() => _TutorsState();
}

class _TutorsState extends State<Tutors> {
  final AuthService _auth = AuthService();

  String userFirstName = "test";

  dynamic data;
  var email = "";

  Future<dynamic> getData(userid) async {
    final DocumentReference document =
        Firestore.instance.collection("Tutors").document(userid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  @override
  void initState() {
    var u = FirebaseAuth.instance.currentUser();
    // final user = Provider.of<User>(context);
    // print(user.uid);

    u.then((value) {
      getData(value.uid);
      email = value.email;

      // print(value.uid);
      Provider.of<UserDataNotifier>(context, listen: false)
          .getTheUser(value.uid);
    });
    super.initState();
  }

  // var _filters = ["Rating", "Classes", "Rate"];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final tutorData = Provider.of<Tutor>(context);

    final userdata = context.watch<UserDataNotifier>();

    var tutor =
        Firestore.instance.collection("Tutors").document(user.uid).get();
    print(tutor.then((value) {
      print(value.data);
    }));

    // final userdata = Provider.of<UserData>(context);
    // print(userdata.firstName);
    var screensize = MediaQuery.of(context).size;

    return StreamProvider<List<Tutor>>.value(
        value: DatabaseService().tutors,
        child: Scaffold(
          backgroundColor: Color(0xff3DDC97),
          appBar: AppBar(
            backgroundColor: Color(0xff46237A),
            actions: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(screensize.width * .19,
                      screensize.height * .01, screensize.width * .2, 0),
                  child: Text(
                    "Tutors",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
              Container(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton.icon(
                    icon: Icon(Icons.exit_to_app),
                    label: Text("Logout"),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: userdata.user == null
                      ? CircularProgressIndicator()
                      : Text(userdata.user.firstName),
                  accountEmail: Text(user.email),
                  currentAccountPicture: CircleAvatar(
                      backgroundColor: Color(0xff3DDC97),
                      child: userdata.user == null
                          ? CircularProgressIndicator()
                          : Text(userdata.user.firstName[0],
                              style: TextStyle(
                                  fontSize: 30, color: Colors.white))),
                ),
                ListTile(
                  title: Text("Home"),
                  trailing: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Classes"),
                  trailing: Icon(Icons.class_),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllClasses()));
                  },
                ),
                ListTile(
                  title: Text("Settings"),
                  trailing: Icon(Icons.settings),
                ),
                ListTile(
                  title: Text("Your Classes"),
                  trailing: Icon(Icons.dock),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => YourClasses()));
                  },
                ),
                ListTile(
                  title: Text("Profile"),
                  trailing: Icon(Icons.person),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                ),
                ListTile(
                  title: Text("Chats"),
                  trailing: Icon(Icons.person),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                ),
                tutorData == null
                    ? CircularProgressIndicator()
                    : tutorData.prof == true
                        ? ListTile(
                            title: Text("Create Class"),
                            trailing: Icon(Icons.add),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateClass()));
                            },
                          )
                        : ListTile()
              ],
            ),
          ),
          body: Stack(children: <Widget>[
            Container(
              child: Center(
                  child: Column(
                children: <Widget>[
                  Expanded(
                    child: TutorsList(),
                  ),
                ],
              )),
            ),
            Container(
              width: screensize.width,
              height: screensize.height * 0.12,
            ),
          ]),
        ));
  }
}
