import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/wrapper.dart';
import 'Services/auth.dart';
import 'Services/database.dart';
import 'models/tutorModel.dart';
import 'models/user.dart';

class BeforeWrapper extends StatelessWidget {
  const BeforeWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserTutor user = Provider.of<UserTutor>(context);
    if (user != null) {
      print(user.uid);
    }
    return Container(
      child: MaterialApp(
        home: user == null
            ? Wrapper()
            : MultiProvider(
                providers: [
                  StreamProvider<List<ClassData>>.value(
                      value: DatabaseService(uid: user.uid).classdata),
                  // StreamProvider<Tutor>.value(
                  //   value: DatabaseService(uid: user.uid).streamTutor,
                  // ),
                ],
                builder: (context, child) {
                  return Wrapper();
                },
                // child: MaterialApp(
                //   home: Wrapper(),
                //   debugShowCheckedModeBanner: false,
                // ),
              ),
      ),
      //   child: MultiProvider(
      // providers: [
      //   // user == null
      //   //     ? StreamProvider<Tutor>.value(
      //   //         value: DatabaseService().streamTutor,
      //   //       )
      //   //     : StreamProvider<Tutor>.value(
      //   //         value: DatabaseService(uid: user.uid).streamTutor,
      //   //       ),
      //   // user == null
      //   //     ? StreamProvider<List<ClassData>>.value(
      //   //         value: DatabaseService().classdata)
      //   //     : StreamProvider<List<ClassData>>.value(
      //   //         value: DatabaseService(uid: user.uid).classdata),
      // ],
      // child: MaterialApp(
      //   home: Wrapper(),
      //   debugShowCheckedModeBanner: false,
      // ),
    );
  }
}
