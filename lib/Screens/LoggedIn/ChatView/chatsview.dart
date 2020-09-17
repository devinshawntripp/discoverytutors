import 'package:flutter/material.dart';

import 'chatlist.dart';

class ChatsView extends StatefulWidget {
  ChatsView({Key key}) : super(key: key);

  @override
  _ChatsViewState createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3DDC97),
      appBar: AppBar(
        backgroundColor: Color(0xff46237A),
      ),
      body: ChatList(),
    );
  }
}
