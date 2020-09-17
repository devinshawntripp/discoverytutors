import 'package:cloud_firestore/cloud_firestore.dart';

import 'messagesModel.dart';

class ChatModel {
  Stream<List<Message>> _messages;
  String chatID;
  List<String> tutorIDS;

  Stream<List<Message>> get messages {
    return Firestore.instance
        .collection("Chats")
        .document(chatID)
        .collection("Messages")
        .snapshots()
        .map((event) => event.documents.map((e) => Message.fromMap(e.data)));
  }

  ChatModel.fromMap(Map<String, dynamic> data, String uid) {
    chatID = uid;
    try {
      tutorIDS = data['tutors'].cast<String>();
    } catch (error) {}
  }

  ChatModel({this.chatID});
}
