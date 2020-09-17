import 'package:disc_t/models/chatModel.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chattile.dart';

class ChatList extends StatefulWidget {
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    Tutor userTutor = Provider.of<Tutor>(context);

    return userTutor == null
        ? Loading()
        : StreamProvider<List<ChatModel>>.value(
            value: userTutor.chats,
            child:
                Consumer<List<ChatModel>>(builder: (context, userChats, child) {
              return userChats == null
                  ? Loading()
                  : ListView.builder(
                      itemCount: userChats.length,
                      itemBuilder: (context, index) {
                        return ChatTile(
                          chatModel: userChats[index],
                          chatID: userChats[index].chatID,
                          tutors: userChats[index].tutorNames,
                        );
                      });
            }));
  }
}
