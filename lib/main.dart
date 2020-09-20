import 'package:disc_t/beforewrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/wrapper.dart';
import 'Services/auth.dart';
import 'Services/database.dart';
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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        ));
  }
}
