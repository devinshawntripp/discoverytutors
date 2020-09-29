import 'package:disc_t/Screens/LoggedIn/ChatView/chatsview.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/createclass.dart';

import 'package:disc_t/Screens/LoggedIn/Classes/yourclasses.dart';
import 'package:disc_t/Screens/LoggedIn/TutorsView/userprofile.dart';
import 'package:disc_t/Services/auth.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';
import 'package:animations/animations.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tutorslist.dart';
import '../Classes/allclasses.dart';

//widget shows all of the tutors using the app

class Tutors extends StatefulWidget {
  @override
  _TutorsState createState() => _TutorsState();
}

class _TutorsState extends State<Tutors> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserTutor>(context);
    final tutorData = Provider.of<Tutor>(context);

    var screensize = MediaQuery.of(context).size;

    return StreamProvider<List<Tutor>>.value(
      value: DatabaseService().tutors,
      child: Scaffold(
        backgroundColor: Colors.green,
        // backgroundColor: Color(0xff3DDC97),
        appBar: AppBar(
          backgroundColor: Color(0xff46237A),
          actions: <Widget>[
            Container(
                margin: EdgeInsets.only(right: screensize.width / 7),
                alignment: Alignment.center,
                // margin: EdgeInsets.fromLTRB(screensize.width * .19,
                //     screensize.height * .01, screensize.width * .2, 0),
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
                  // color: Colors.blue,
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
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
                accountName: tutorData == null
                    ? CircularProgressIndicator()
                    : Text(tutorData.firstName),
                accountEmail: Text(user.email),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Color(0xff3DDC97),
                    child: tutorData == null
                        ? CircularProgressIndicator()
                        : Text(tutorData.firstName[0],
                            style:
                                TextStyle(fontSize: 30, color: Colors.white))),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StreamProvider<List<ClassData>>.value(
                                value: DatabaseService(uid: user.uid).classdata,
                                child: AllClasses(),
                              )));
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StreamProvider<List<ClassData>>.value(
                                value: DatabaseService(uid: user.uid).classdata,
                                child: YourClasses(
                                  userdata: tutorData,
                                ),
                              )));
                },
              ),
              ListTile(
                title: Text("Profile"),
                trailing: Icon(Icons.person),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfile(
                                tutor: tutorData,
                              )));
                },
              ),
              ListTile(
                title: Text("Chats"),
                trailing: Icon(Icons.chat),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatsView(
                                userTutor: tutorData,
                              )));
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
                  child: TutorsList(
                    userTutor: tutorData,
                  ),
                ),
              ],
            )),
          ),
          Container(
            width: screensize.width,
            height: screensize.height * 0.12,
          ),
        ]),
      ),
    );
  }
}
