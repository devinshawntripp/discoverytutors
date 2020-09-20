import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/Authenticate/signinandregister.dart';
import 'Screens/LoggedIn/TutorsView/tutors.dart';
import 'Screens/RegisterDecider/registerTutor.dart';
import 'models/tutorModel.dart';
import 'models/user.dart';

class AfterWrapper extends StatelessWidget {
  const AfterWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserTutor>(context);

    if (user == null) {
      return SignIn();
    } else {
      Tutor tutor = Provider.of<Tutor>(context);

      if (tutor != null) {
        if (tutor.firstName == null) {
          return RegisterTutor();
        } else {
          return Tutors();
        }
      } else {
        return RegisterTutor();
      }
    }
    // return Container(
    //   child: Text(""),
    // );
  }
}
