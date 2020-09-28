import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/Screens/LoggedIn/ChatView/chat.dart';
import 'package:disc_t/models/chatModel.dart';
import 'package:disc_t/models/messagesModel.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatefulWidget {
  final String chatID;
  final List<String> tutors;
  final ChatModel chatModel;
  final Tutor userTutor;
  final int index;
  ChatTile(
      {Key key,
      this.chatID,
      this.tutors,
      this.chatModel,
      this.userTutor,
      this.index})
      : super(key: key);

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    // Tutor userTutor = Provider.of<Tutor>(context);
    List<String> tutorsWithoutUser = List<String>();
    // List<Tutor> tutorsWU = List<Tutor>();
    // print("Docid");
    // print(widget.userTutor.docid);

    if (widget.userTutor != null) {
      tutorsWithoutUser = widget.tutors
          .where((element) => !element
              .toLowerCase()
              .contains(widget.userTutor.firstName.toLowerCase()))
          .toList();
    }

    return widget.userTutor == null
        ? Loading()
        : tutorsWithoutUser == null
            ? Loading()
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StreamProvider<List<Message>>.value(
                                value: widget.chatModel.messages,
                                child: Chat(
                                  chatModel: widget.chatModel,
                                  chatID: widget.chatID,
                                  userTutor: widget.userTutor,
                                ),
                              )));
                },
                child: Column(children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.white,
                    child: Container(
                        // color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 10,
                        child: Column(children: <Widget>[
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: (MediaQuery.of(context).size.height /
                                          10) /
                                      3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Users: "),
                                  for (var item in tutorsWithoutUser) Text(item)
                                ],
                              ),
                            ),
                          ),
                        ])),
                  )
                ]),
              );
  }
}
