import 'package:disc_t/Screens/LoggedIn/TutorsView/tutors.dart';
import 'package:disc_t/Screens/RegisterDecider/registerTutor.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/afterwrapper.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Authenticate/signinandregister.dart';

class Wrapper extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserTutor>(context);
    // final tutor = Provider.of<Tutor>(context); //could refactor to this method

    //either return the sign in and register widget or return the Tutors widget

    if (user == null) {
      return SignIn();
    } else {
      return StreamProvider<Tutor>.value(
        value: DatabaseService(uid: user.uid).streamTutor,
        child: AfterWrapper(),
      );

      // builder: (context, child) {
      //   if (user == null) {
      //     return SignIn();
      //   } else {
      //     Tutor tutor = Provider.of<Tutor>(context);

      //     if (tutor == null) {
      //       return RegisterTutor();
      //     } else {
      //       return Tutors();
      //     }

      //     // StreamBuilder<Tutor>(
      //     //   stream: DatabaseService(uid: user.uid).streamTutor,
      //     //   builder: (context, snapshot) {
      //     //     print(" Here is the data ${snapshot.data}");
      //     //     if (snapshot.hasData) {
      //     //       // final FirebaseAuth _auth = FirebaseAuth.instance;
      //     //       // _auth.signOut();

      //     //       // return Text("");

      //     //       return Tutors();
      //     //     } else {
      //     //       return RegisterTutor();
      //     //     }
      //     //   },
      //     // );
      //   }
      // },

    }
  }
}
