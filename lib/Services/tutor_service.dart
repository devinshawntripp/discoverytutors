import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/models/chatModel.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';

class TutorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserTutor user;
  TutorService({this.user});

  final chatsCollection = FirebaseFirestore.instance.collection("Chats");
  final tutorsCollection = FirebaseFirestore.instance.collection("Tutors");

  Stream<Tutor> get streamTutor {
    if (user == null) {
      return null;
    } else {
      if (user.name == null) {
        return _firestore
            .collection("Tutors")
            .doc(user.uid)
            .snapshots()
            .map((event) => Tutor.fromMap(event.data(), event.id, user));
      } else {}
    }
  }

  Future deleteChat(ChatModel chatmodel, Tutor userTutor) async {
    //loop through the tutors and delete the chats from them
    List<String> tutorids = chatmodel.tutorIDS;
    int i = 0;

    await Future.forEach(tutorids, (element) async {
      final chats = await tutorsCollection.doc(tutorids[i]).get();
      final cwiths = tutorsCollection.doc(tutorids[i]).snapshots().where(
          (event) => event.data()['chats'].removeWhere(
              (e) => event.data()['chats'].contains(chatmodel.chatID)));
      cwiths.map((event) => print(event.id));
      final chatsWiths = await tutorsCollection.doc(tutorids[i]).get();
      int k = 0;
      List<dynamic> userChatIds = chats.get('chats');
      var toRemove = [];
      await Future.forEach(userChatIds, (element) async {
        if (k < userChatIds.length) {
          if (userChatIds[k] == chatmodel.chatID) {
            toRemove.add(userChatIds[k]);
          }
        }

        k++;
      });
      userChatIds.removeWhere((e) => toRemove.contains(e));
      print(userChatIds);

      int l = 0;
      List<dynamic> userChatWiths = chatsWiths.get('chatsWith');
      var toRemoveChatWiths = [];
      await Future.forEach(userChatWiths, (element) async {
        if (l < userChatWiths.length) {
          int p = 0;
          await Future.forEach(tutorids, (element) async {
            if (p < tutorids.length) {
              if (userChatWiths[l] == tutorids[p]) {
                toRemoveChatWiths.add(userChatWiths[l]);
              }
            }
            p++;
          });
        }
        l++;
      });

      userChatWiths
          .removeWhere((element) => toRemoveChatWiths.contains(element));
      print(userChatWiths);
      await tutorsCollection.doc(tutorids[i]).update({
        'chats': userChatIds,
        'chatsWith': userChatWiths,
      });

      i++;
    });

    return await chatsCollection.doc(chatmodel.chatID).delete();
  }
}
