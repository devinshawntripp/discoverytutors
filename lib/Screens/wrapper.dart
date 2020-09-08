import 'package:disc_t/Screens/LoggedIn/TutorsView/tutors.dart';
import 'package:disc_t/Screens/RegisterDecider/registerTutor.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Authenticate/signinandregister.dart';

class Wrapper extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // final userdata = Provider.of<UserData>(context);
    //print("User data = ${user.uid}");
    // print("the user data is " + userdata.toString());
    print(" I WAS ABLE TO REACH HERE");
    //either return the sign in and register widget or return the Tutors widget
    if (user == null) {
      return SignIn();
    } else {
      // if(clickedRegister == true){
      //   return Register();
      // } else {
      return Tutors();
      // return StreamBuilder<UserData>(
      //   stream: DatabaseService(uid: user.uid).userdata,
      //   builder: (context, snapshot) {
      //     print(" Here is the data ${snapshot.data}");
      //     if (snapshot.hasData) {
      //       return Tutors();
      //     } else {
      //       return RegisterTutor();
      //     }
      //   },
      // );
      // if(userdata.firstName == null){
      //   //send them to the register page
      //   return Register();
      // } else {
      //   return Tutors();
      // }
      //need to get the data for the user and if it returns null
      // }

    }
  }
}
