import 'dart:io';

import 'package:disc_t/Services/auth.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  //form field state
  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  double cardHeight = 0.30;

  @override
  Widget build(BuildContext context) {
    final widthOfPage = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Color(0xff7211E0),
            //   // Here we take the value from the MyHomePage object that was created by
            //   // the App.build method, and use it to set our appbar title.
            //   title: Text("DISCOVERY TUTORS"),
            // ),
            body: Center(
              child: Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                        width: widthOfPage,
                        color: Color(0xffFCFCFC),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: widthOfPage / 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "DISCOVERY",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  wordSpacing: -1.5,
                                ),
                                textScaleFactor: 2.5,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: widthOfPage / 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "TUTORS",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  wordSpacing: -1.5,
                                ),
                                textScaleFactor: 2.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   //add logo
                      //   margin: EdgeInsets.only(
                      //       top: MediaQuery.of(context).size.height * 0.02),
                      //   child: Image.asset(
                      //     'assets/Unt-Logo.png',
                      //     height: 100,
                      //   ),
                      // ),
                      Container(
                        // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/),
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .02),
                        // height:
                        //     (MediaQuery.of(context).size.height * cardHeight * 1.3),
                        width: MediaQuery.of(context).size.width * .90,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Form(
                                key: _formkey,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      // margin: EdgeInsets.only(
                                      //     top: MediaQuery.of(context)
                                      //             .size
                                      //             .height *
                                      //         0.03),
                                      width: 300,
                                      child: TextFormField(
                                        validator: (val) => val.isEmpty
                                            ? "Enter an email"
                                            : null,
                                        // style: new TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),

                                            // fillColor: Colors.white,
                                            // filled: true,
                                            // hintStyle: new TextStyle(color: Colors.white),
                                            hintText: "Email:",
                                            hintStyle:
                                                TextStyle(color: Colors.white)),

                                        onChanged: (val) {
                                          setState(() => email = val);
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 25),
                                      width: 300,
                                      child: TextFormField(
                                        validator: (val) => val.length < 6
                                            ? "Enter a password that is 6 chars long"
                                            : null,
                                        // style: new TextStyle(color: Colors.white),
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          // fillColor: Colors.white,
                                          // filled: true,
                                          // hintStyle: new TextStyle(color: Colors.white),
                                          hintText: "Password:",
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            password = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 300,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 25),
                                      margin: EdgeInsets.only(left: 12),
                                      width: 100,
                                      height: 75,
                                      child: RaisedButton(
                                        onPressed: () async {
                                          if (_formkey.currentState
                                              .validate()) {
                                            setState(() => loading = true);
                                            dynamic result = await _auth
                                                .signInEAP(email, password);
                                            if (result == null) {
                                              setState(() {
                                                error =
                                                    "please enter valid credentials";
                                                loading = false;
                                              });
                                            }
                                          } else {
                                            loading = false;
                                          }
                                        },
                                        child: Text(
                                          "Signin",
                                          style: new TextStyle(
                                              color: Color(0xffFCFCFC)),
                                        ),
                                        color: Color(0xff256EFF),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                new Radius.circular(60))),
                                        elevation: 10,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 25),
                                      margin: EdgeInsets.only(left: 75),
                                      width: 100,
                                      height: 75,
                                      child: RaisedButton(
                                        onPressed: () async {
                                          //later see if anything is typed in and pass values through to register
                                          print("working");

                                          if (_formkey.currentState
                                              .validate()) {
                                            setState(() => loading = true);
                                            dynamic result = await _auth.signUp(
                                                email, password);
                                            if (result == null) {
                                              setState(() {
                                                error =
                                                    "account is already in use";
                                                loading = false;
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              cardHeight = cardHeight + 0.025;
                                              loading = false;
                                            });
                                          }
                                        },
                                        child: Text(
                                          "Signup",
                                          style: new TextStyle(
                                              color: Color(0xffFCFCFC)),
                                        ),
                                        color: Color(0xff256EFF),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                new Radius.circular(60))),
                                        elevation: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 12.0,
                              // ),
                              Text(
                                error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () async {
                            await _auth.signInWithApple();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.apple),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Sign in With Apple",
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(60))),
                          elevation: 10,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () async {
                            await _auth.signInWithGoogle();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Sign in with Google",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          color: Color(0xff256EFF),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(60))),
                          elevation: 10,
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 10),
                      //   width: MediaQuery.of(context).size.width / 1.2,
                      //   height: 50,
                      //   child: RaisedButton(
                      //     onPressed: () async {
                      //       dynamic result = await _auth.signInAnon();
                      //       if (result == Null) {
                      //         print("user not signed in");
                      //       } else {
                      //         print("user signed in");
                      //         print(result.uid);
                      //       }
                      //     },
                      //     child: Text(
                      //       "Guest",
                      //       style: new TextStyle(
                      //         color: Color(0xffFCFCFC),
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //     ),
                      //     color: Color(0xff256EFF),
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius:
                      //             BorderRadius.all(new Radius.circular(60))),
                      //     elevation: 10,
                      //   ),
                      // ),
                    ],
                  )),
            ),
            backgroundColor: Colors.black,
          );
  }
}
