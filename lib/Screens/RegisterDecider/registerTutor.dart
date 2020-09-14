import 'package:disc_t/Screens/RegisterDecider/classlist.dart';
import 'package:disc_t/Services/auth.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class RegisterTutor extends StatefulWidget {
  @override
  _RegisterTutorState createState() => _RegisterTutorState();
}

class _RegisterTutorState extends State<RegisterTutor> {
  bool loading = false;

  final _formkey = GlobalKey<FormState>();
  final _database = DatabaseService();
  final _auth = AuthService();
  int _rate = 0;
  String firstname = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xff3DDC97),
            appBar: AppBar(
              backgroundColor: Color(0xff3DDC97),
            ),
            body: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.90,
                child: Card(
                  elevation: 30.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(new Radius.circular(60))),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                validator: (val) =>
                                    val.isEmpty ? "Enter a Name" : null,
                                decoration:
                                    InputDecoration(hintText: "First Name"),
                                onChanged: (val) {
                                  setState(() => firstname = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Pick the classes you have taken"),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 100,
                        child: ClassList(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 100,
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width * .1,
                                    0,
                                    10,
                                    0),
                                child: Text("Rate: \$$_rate per hour")),
                            NumberPicker.integer(
                              initialValue: 0,
                              minValue: 0,
                              maxValue: 100,
                              onChanged: (val) {
                                setState(() {
                                  _rate = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            setState(() => loading = true);
                            await _database.registerTutor(
                                user, firstname, takenClasses, _rate);
                            takenClasses = [];
                          } else {
                            loading = false;
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(new Radius.circular(60))),
                        color: Color(0xff256EFF),
                        child: Text("Sign Up"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
