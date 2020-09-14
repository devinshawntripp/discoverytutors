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
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: Consumer<User>(
          builder: (_, user, __) {
            return MultiProvider(
              providers: [
                // StreamProvider<List<ClassData>>.value(
                //     value: DatabaseService().classdata),
                // StreamProvider<UserData>.value(
                //     value: Stream.fromFuture(UserData().getTheUserClasses())),
                // StreamProvider<List<Homework>>.value(
                //     value: ClassDataNotifier().homework),
                user == null
                    ? StreamProvider<Tutor>.value(
                        value: DatabaseService().streamTutor,
                      )
                    : StreamProvider<Tutor>.value(
                        value: DatabaseService(uid: user.uid).streamTutor,
                      ),
                user == null
                    ? StreamProvider<List<ClassData>>.value(
                        value: DatabaseService().classdata)
                    : StreamProvider<List<ClassData>>.value(
                        value: DatabaseService(uid: user.uid).classdata),
                user == null
                    ? StreamProvider<UserData>.value(
                        value: DatabaseService().streamuserdata,
                      )
                    : StreamProvider<UserData>.value(
                        value: DatabaseService(uid: user.uid).streamuserdata,
                      ),
                ChangeNotifierProvider(
                  create: (context) => ClassDataNotifier(),
                ),
                ChangeNotifierProvider(
                  create: (context) => UserDataNotifier(),
                )
                // StreamProvider<UserData>.value(
                //   value: DatabaseService().userdata,
                // ),
              ],
              child: MaterialApp(
                home: Wrapper(),
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        ));
  }
}
