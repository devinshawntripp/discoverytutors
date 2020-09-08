import 'package:disc_t/Screens/wrapper.dart';
import 'package:disc_t/Services/auth.dart';
import 'package:disc_t/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Screens/wrapper.dart';
import './models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // final DatabaseService ds = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().user,
        ),
        ChangeNotifierProvider(
          create: (context) => ClassDataNotifier(),
        ),
      ],
      child: MaterialApp(home: Wrapper()),
    );
  }
}
