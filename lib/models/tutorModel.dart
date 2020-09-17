import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/Screens/LoggedIn/ChatView/chat.dart';
import 'package:disc_t/models/chatModel.dart';

class Tutor {
  int totalVotes;
  int contributions;
  String firstName;
  int rating;
  String docid;
  int rate;
  List<String> classes;
  bool prof;
  String tutorID;
  List<String> chatIDs;
  List<String> chatWiths;

  Stream<List<ChatModel>> _chats;

  Stream<List<ChatModel>> get chats {
    return Firestore.instance.collection("Chats").snapshots().map((event) =>
        event.documents
            .where((element) =>
                (element.data['tutors'].cast<String>().contains(docid) == true))
            .map((e) => ChatModel.fromMap(e.data, e.documentID))
            .toList());
  }

  set chats(Stream<List<ChatModel>> s) {
    _chats = s;
  }

  // Stream<ChatModel>() {
  //   return Firestore.instance.collection("Chats");
  // }

  Tutor.fromMap(Map<String, dynamic> data, String docid) {
    this.totalVotes = data['totalvotes'];
    this.docid = docid;
    this.rating = data['rating'];
    this.rate = data['rate'];
    this.prof = data['prof'] ?? false;
    this.tutorID = data['tutorid'];
    try {
      this.classes = data['classes'].cast<String>();
      this.chatIDs = data['chats'].cast<String>();
      this.chatWiths = data['chatsWith'].cast<String>();
    } catch (error) {}

    this.firstName = data['firstname'];
    this.contributions = data['Contributions'];
  }

  Tutor(
      {this.firstName,
      this.rating,
      this.docid,
      this.classes,
      this.rate,
      this.contributions,
      this.totalVotes,
      this.prof,
      this.chatIDs,
      this.chatWiths});
}
