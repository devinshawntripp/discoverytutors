import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/models/chatModel.dart';
import 'package:disc_t/models/user.dart';

class Tutor {
  int totalVotes = 0;
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
  String profPicURL;

  Stream<List<ChatModel>> _chats;

  Stream<List<ChatModel>> get chats {
    return FirebaseFirestore.instance.collection("Chats").snapshots().map(
        (event) => event.docs
            .where((element) =>
                (element.data()['tutors'].cast<String>().contains(docid) ==
                    true))
            .map((e) => ChatModel.fromMap(e.data(), e.id))
            .toList());
  }

  //delete a users chats - will delete chat from the other user as well

  set chats(Stream<List<ChatModel>> s) {
    _chats = s;
  }

  // Stream<ChatModel>() {
  //   return Firestore.instance.collection("Chats");
  // }

  Tutor.fromMap(Map<String, dynamic> data, String docid, UserTutor userTutor) {
    if (data != null) {
      if (data.isEmpty) {
      } else {
        this.docid = docid;
        this.profPicURL = data['profpicurl'] ?? '';
        if (userTutor.name != null) {
          print("name found");
        } else {}
        this.firstName = data['firstname'] ?? '';
        this.tutorID = data['tutorid'];
        this.prof = data['prof'] ?? false;
        this.contributions = data['Contributions'];
        try {
          this.rate = data['rate'];
          this.rating = data['rating'];
          this.totalVotes = data['totalvotes'];
          this.classes = data['classes'].cast<String>();
          this.chatIDs = data['chats'].cast<String>();
          this.chatWiths = data['chatsWith'].cast<String>();
        } catch (error) {}
      }
    }
  }

  Tutor({
    this.firstName,
    this.rating,
    this.docid,
    this.classes,
    this.rate,
    this.contributions,
    this.totalVotes,
    this.prof,
    this.chatIDs,
    this.chatWiths,
    this.profPicURL,
  });
}
