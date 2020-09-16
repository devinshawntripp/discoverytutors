import 'package:disc_t/Screens/LoggedIn/TutorsView/tutorsclasslist.dart';
import 'package:disc_t/Screens/LoggedIn/ratinglist.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // final String tutorname;
  // final String docid;
  // final List<String> tutorsclasses;
  // final tutor = Provider.of<Tutor>(context);

  @override
  @override
  void initState() {
    // DatabaseService().sumContributions(widget.tutor);
    // DatabaseService().sumVotes(widget.tutor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(tutor.classes);
    // String tutorRate;
    final tutor = Provider.of<Tutor>(context);
    return tutor == null
        ? CircularProgressIndicator()
        : Scaffold(
            backgroundColor: Color(0xff3DDC97),
            appBar: AppBar(
              backgroundColor: Color(0xff7211E0),
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              //create messaging for tutors
              title: Text(tutor.firstName),
            ),
            body: Center(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              SizedBox(
                height: 40,
              ),
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 75,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Classes Taken",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
              Expanded(
                  child: Container(
                      height: 300,
                      child: TutorsClassList(classes: tutor.classes))),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      // SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Rating: ",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Color(0xffFCFCFC),
                                    fontWeight: FontWeight.w800),
                              ),
                              Expanded(
                                child: RatingsList(
                                  tutor: tutor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height * 0.10,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(("RATE P/H: ${tutor.rate}"),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffFCFCFC),
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      //get each users contributions
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text("Contributions: ${tutor.contributions}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xffFCFCFC),
                                fontWeight: FontWeight.w800)),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text("Votes: ${tutor.totalVotes}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xffFCFCFC),
                                fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }
}