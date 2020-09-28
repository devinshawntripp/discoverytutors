import 'package:disc_t/Services/tutor_service.dart';
import 'package:disc_t/models/chatModel.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    final _tutorService = TutorService();

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
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ChatTile(
                            chatModel: userChats[index],
                            chatID: userChats[index].chatID,
                            tutors: userChats[index].tutorNames,
                            userTutor: userTutor,
                            index: index,
                          ),
                          actions: [],
                          secondaryActions: [
                            IconSlideAction(
                              caption: "Delete",
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                _tutorService.deleteChat(
                                    userChats[index], userTutor);
                              },
                            )
                          ],
                        );
                      });
            }));
  }
}
