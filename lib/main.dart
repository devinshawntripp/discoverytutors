import 'package:disc_t/Screens/Authenticate/signinandregister.dart';
import 'package:disc_t/Screens/RegisterDecider/registerTutor.dart';
import 'package:disc_t/Services/tutor_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/LoggedIn/TutorsView/tutors.dart';

import 'Services/auth.dart';

import 'models/tutorModel.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // final DatabaseService ds = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserTutor>.value(
      value: AuthService().user,
      builder: (context, child) {
        UserTutor user = Provider.of<UserTutor>(context);
        return MultiProvider(
          providers: [
            StreamProvider<Tutor>.value(
              value: TutorService(user: user).streamTutor,
            )
          ],
          builder: (context, child) {
            Tutor tutor = Provider.of<Tutor>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: user == null
                  ? SignIn()
                  : tutor == null ? RegisterTutor() : Tutors(),
            );
          },
        );
      },
    );
  }
}
