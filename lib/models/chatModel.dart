import 'package:cloud_firestore/cloud_firestore.dart';

import 'messagesModel.dart';

class ChatModel {
  Stream<List<Message>> _messages;
  String chatID;
  List<String> tutorIDS;
  List<String> tutorNames;

  set messages(Stream<List<Message>> s) {
    _messages = s;
  }

  Stream<List<Message>> get messages {
    final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse('2019-03-13 16:49:42.044').millisecondsSinceEpoch);
    return Firestore.instance
        .collection("Chats")
        .document(chatID)
        .collection("Messages")
        .orderBy("timeStamp", descending: false)
        .startAt([startAtTimestamp])
        .limit(100)
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Message.fromMap(e.data)).toList());
  }

  Future<void> sendChat(String content, String idFrom, String type) async {
    await Firestore.instance
        .collection("Chats")
        .document(chatID)
        .collection("Messages")
        .add({
      'content': content,
      'idfrom': idFrom,
      'timeStamp': FieldValue.serverTimestamp(),
      'type': type
    });
  }

  ChatModel.fromMap(Map<String, dynamic> data, String uid) {
    chatID = uid;
    try {
      tutorIDS = data['tutors'].cast<String>();
      tutorNames = data['tutorNames'].cast<String>();
    } catch (error) {}
  }

  ChatModel({this.chatID});
}
