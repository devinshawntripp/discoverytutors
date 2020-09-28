import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/models/classMaterialModel.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';

class DatabaseService {
  final String uid;

  //constructor
  DatabaseService({this.uid});

  final tutorsCollection = FirebaseFirestore.instance.collection("Tutors");
  final classesCollection = FirebaseFirestore.instance.collection("Classes");
  final homeworkCollection = FirebaseFirestore.instance.collection("Classes");
  final hworkCollection = FirebaseFirestore.instance.collection("Homework");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final allClassesCollection =
  //     FirebaseFirestore.instance.collection("Tutors/allclasses");

  Future getUserName(UserTutor user) async {
    await tutorsCollection.doc(user.uid).get();
  }

  Future registerTutor(
      UserTutor user, String firstname, List<String> classes, int rate) async {
    return await tutorsCollection.doc(user.uid).set({
      'firstname': firstname,
      'rating': 0,
      'classes': FieldValue.arrayUnion(classes),
      'rate': rate ?? 0,
      'Contributions': 0,
      'totalvotes': 0,
      'prof': false,
      'tutorID': user.uid
    });
  }

  Future createChat(Tutor tutorClicked, Tutor userTutor) async {
    return await FirebaseFirestore.instance.collection("Chats").add({
      'tutors': FieldValue.arrayUnion([tutorClicked.docid, userTutor.docid]),
      'tutorNames':
          FieldValue.arrayUnion([tutorClicked.firstName, userTutor.firstName]),
      'timestamp': FieldValue.serverTimestamp()
    }).then((value) {
      tutorsCollection.doc(tutorClicked.docid).update({
        'chats': FieldValue.arrayUnion([value.id]),
        'chatsWith': FieldValue.arrayUnion([userTutor.docid])
      });
      tutorsCollection.doc(userTutor.docid).update({
        'chats': FieldValue.arrayUnion([value.id]),
        'chatsWith': FieldValue.arrayUnion([tutorClicked.docid])
      });
    });
  }

  Future deleteHomework(String docid, String classid, String collection) async {
    return await classesCollection
        .doc(classid)
        .collection(collection)
        .doc(docid)
        .delete();
  }

  // Stream<List<UserClassData> get userClassData {
  //       return _firestore
  //       .collection("Classes")
  //       .where('tutors', arrayContains: uid)
  //       .snapshots()
  //       .map((event) => event.documents
  //           .map((e) => UserClassData.fromMap(e.data, e.documentID))
  //           .toList());

  // }

  Stream<List<ClassData>> get classdata {
    return _firestore.collection("Classes").snapshots().map(
        (QuerySnapshot snapshot) => snapshot.docs
            .map((e) => ClassData.fromUserMapStream(e.data(), e.id, uid))
            .toList());
  }

  Stream<Tutor> get streamTutor {
    return _firestore
        .collection("Tutors")
        .doc(uid)
        .snapshots()
        .map((event) => Tutor.fromMap(event.data(), event.id));
  }

  Future createHomework(
      UserTutor user,
      String filename,
      String docid,
      int upvotes,
      int downvotes,
      int rank,
      String imageLocation,
      String classid,
      String collection,
      String userid) async {
    return await classesCollection.doc(classid).collection(collection).add({
      "Image": imageLocation,
      "filename": filename,
      "docid": "",
      "uid": user.uid,
      "upvotes": upvotes,
      "downvotes": downvotes,
      "rank": 0 //will calculate later
    }).then((value) {
      value.update({'docid': value.id});
      tutorsCollection.doc(userid).update({'Homework': value.id});
    });
  }

  Stream<List<Tutor>> get tutors {
    return tutorsCollection.snapshots().map(_tutorsListFromSnapshot);
  }

  Future uploadUserPhoto(Tutor tutor, String storageFileName) async {
    await FirebaseFirestore.instance
        .collection("Tutors")
        .doc(tutor.docid)
        .update({'profpicurl': storageFileName});
  }

  Future downVote(
      dynamic classMaterial, String collection, String classid) async {
    return await classesCollection
        .doc(classid)
        .collection(collection)
        .doc()
        .update({
      "upvotes": FieldValue.increment(1),
    });
  }

  Future upVote(
      dynamic classMaterial, String collection, String classid) async {
    return await classesCollection
        .doc(classid)
        .collection(collection)
        .doc()
        .update({
      "downvotes": FieldValue.increment(1),
    });
  }

  void sumContributions(Tutor tutor) async {
    int totalContributions = 0;
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Classes").get();

    await Future.forEach(snapshot.docs, (document) async {
      // ClassData data = ClassData.fromMap(document.data);
      await FirebaseFirestore.instance
          .collection("Classes")
          .doc(document.documentID)
          .collection("Homework")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element.data()['uid'] == tutor.docid) {
            totalContributions++;
          }
        });
      });
      await FirebaseFirestore.instance
          .collection("Classes")
          .doc(document.documentID)
          .collection("Notes")
          .get()
          .then((value) {
        value.documents.forEach((element) {
          if (element.data()['uid'] == tutor.docid) {
            totalContributions++;
          }
        });
      });
      await FirebaseFirestore.instance
          .collection("Classes")
          .doc(document.documentID)
          .collection("Tests")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element.data()['uid'] == tutor.docid) {
            totalContributions++;
          }
        });
      });

      FirebaseFirestore.instance
          .collection("Tutors")
          .doc(tutor.docid)
          .update({"Contributions": totalContributions});
    });
  }

  Future<void> addClassesToUser(
      List<String> classesPassed, String uid, List<ClassData> classes) async {
    for (String c in classesPassed) {
      await FirebaseFirestore.instance.collection("Tutors").doc(uid).update({
        "classes": FieldValue.arrayUnion([c])
      });
      await FirebaseFirestore.instance.collection("Classes").doc(c).update({
        "tutors": FieldValue.arrayUnion([uid]) ?? [uid]
      });
    }
  }

  Future<void> deleteClassesNotPicked(
      List<String> classNotPassed, String uid, List<ClassData> classes) async {
    for (String c in classNotPassed) {
      //search for first class
      await FirebaseFirestore.instance.collection("Tutors").doc(uid).update({
        "classes": FieldValue.arrayRemove([c])
      });
      await FirebaseFirestore.instance.collection("Classes").doc(c).update({
        "tutors": FieldValue.arrayRemove([uid]) ?? [uid]
      });
    }
  }

  void sumVotes(Tutor tutor) async {
    int totalVotes = 0;
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Classes").get();

    await Future.forEach(snapshot.docs, (document) async {
      // ClassData data = ClassData.fromMap(document.data);
      await FirebaseFirestore.instance
          .collection("Classes")
          .doc(document.documentID)
          .collection("Homework")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element.data()['uid'] == tutor.docid) {
            totalVotes +=
                element.data()['upvotes'] - element.data()['downvotes'];
          }
        });
      });
      await FirebaseFirestore.instance
          .collection("Classes")
          .doc(document.documentID)
          .collection("Notes")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element.data()['uid'] == tutor.docid) {
            totalVotes +=
                element.data()['upvotes'] - element.data()['downvotes'];
          }
        });
      });
      await FirebaseFirestore.instance
          .collection("Classes")
          .doc(document.documentID)
          .collection("Tests")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element.data()['uid'] == tutor.docid) {
            totalVotes +=
                element.data()['upvotes'] - element.data()['downvotes'];
          }
        });
      });

      FirebaseFirestore.instance
          .collection("Tutors")
          .doc(tutor.docid)
          .update({"Contributions": totalVotes});
    });
  }

  List<Tutor> _tutorsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      if (doc.data()['classes'] != null) {
        return Tutor(
          contributions: doc.data()['Contributions'] ?? 0,
          firstName: doc.data()['firstname'] ?? '',
          rating: doc.data()['rating'] ?? 0,
          docid: doc.id,
          classes: doc.data()['classes'].cast<String>() ?? [],
          rate: doc.data()['rate'] ?? 0,
          totalVotes: doc.data()['totalvotes'] ?? 0,
          profPicURL: doc.data()['profpicurl'] ?? '',
        );
      } else {
        return Tutor(
          contributions: doc.data()['Contributions'] ?? 0,
          firstName: doc.data()['firstname'] ?? '',
          rating: doc.data()['rating'] ?? 0,
          docid: doc.id,
          classes: [],
          rate: doc.data()['rate'] ?? 0,
          totalVotes: doc.data()['totalvotes'] ?? 0,
          profPicURL: doc.data()['profpicurl'] ?? '',
        );
      }
    }).toList();
  }

  Stream<List<Homework>> get homeworks {
    return hworkCollection.snapshots().map((_hworkFromSnapshot));
  }

  List<Homework> _hworkFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {}).toList();
  }

  ClassData getClass(String classid) {
    classesCollection.doc(classid).collection("Homeworks").get();
  }
}
