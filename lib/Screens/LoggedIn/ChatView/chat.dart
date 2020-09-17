import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  String chatID;

  Chat({Key key, this.chatID}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3DDC97),
      appBar: AppBar(
        backgroundColor: Color(0xff7211E0),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //create messaging for tutors
        title: Text(widget.chatID),
      ),
      body: Text("Hello"),
    );
  }
}
