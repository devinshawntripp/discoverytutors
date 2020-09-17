import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/Screens/LoggedIn/ChatView/chat.dart';
import 'package:disc_t/models/chatModel.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatefulWidget {
  final String chatID;
  final List<String> tutors;
  final ChatModel chatModel;
  ChatTile({Key key, this.chatID, this.tutors, this.chatModel})
      : super(key: key);

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    Tutor userTutor = Provider.of<Tutor>(context);
    List<String> tutorsWithoutUser = List<String>();
    // List<Tutor> tutorsWU = List<Tutor>();

    if (userTutor != null) {
      tutorsWithoutUser = widget.tutors
          .where((element) => !element
              .toLowerCase()
              .contains(userTutor.firstName.toLowerCase()))
          .toList();
    }

    return userTutor == null
        ? Loading()
        : tutorsWithoutUser == null
            ? Loading()
            : Hero(
                tag: true,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chat(
                                  chatModel: widget.chatModel,
                                  chatID: widget.chatID,
                                )));
                  },
                  child: Column(children: <Widget>[
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Column(children: <Widget>[
                          Text(widget.chatID),
                          Row(
                            children: <Widget>[
                              for (var item in tutorsWithoutUser) Text(item)
                            ],
                          ),
                        ]))
                  ]),
                ),
              );
  }
}
