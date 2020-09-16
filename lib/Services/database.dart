import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/Services/auth.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;

  //constructor
  DatabaseService({this.uid});

  final tutorsCollection = Firestore.instance.collection("Tutors");
  final classesCollection = Firestore.instance.collection("Classes");
  final homeworkCollection = Firestore.instance.collection("Classes");
  final hworkCollection = Firestore.instance.collection("Homework");
  final Firestore _firestore = Firestore.instance;

  final allClassesCollection =
      Firestore.instance.collection("Tutors/allclasses");

  Future getUserName(User user) async {
    await tutorsCollection.document(user.uid).get();
  }

  Future registerTutor(
      User user, String firstname, List<String> classes, int rate) async {
    return await tutorsCollection.document(user.uid).setData({
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

  Future deleteHomework(String docid, String classid, String collection) async {
    return await classesCollection
        .document(classid)
        .collection(collection)
        .document(docid)
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
        (QuerySnapshot snapshot) => snapshot.documents
            .map((e) => ClassData.fromUserMapStream(e.data, e.documentID, uid))
            .toList());
  }

  Stream<UserData> get streamuserdata {
    //get the user classes first
    return _firestore
        .collection("Tutors")
        .document(uid)
        .snapshots()
        .map((event) => UserData.fromMap(event.data));
  }

  Stream<Tutor> get streamTutor {
    //get the user classes first
    return _firestore
        .collection("Tutors")
        .document(uid)
        .snapshots()
        .map((event) => Tutor.fromMap(event.data, event.documentID));
  }

  Future createHomework(
      User user,
      String filename,
      String docid,
      int upvotes,
      int downvotes,
      int rank,
      String imageLocation,
      String classid,
      String collection,
      String userid) async {
    return await classesCollection
        .document(classid)
        .collection(collection)
        .add({
      "Image": imageLocation,
      "filename": filename,
      "docid": "",
      "uid": user.uid,
      "upvotes": upvotes,
      "downvotes": downvotes,
      "rank": 0 //will calculate later
    }).then((value) {
      value.updateData({'docid': value.documentID});
      tutorsCollection
          .document(userid)
          .updateData({'Homework': value.documentID});
    });
  }

  Stream<List<AllClassesData>> get allclasses {
    //some test code to see if this compiles
    Stream<List<AllClassesData>> something;

    return something;
  }

  Stream<List<Tutor>> get tutors {
    return tutorsCollection.snapshots().map(_tutorsListFromSnapshot);
  }

  void sumContributions(Tutor tutor) async {
    int totalContributions = 0;
    QuerySnapshot snapshot =
        await Firestore.instance.collection("Classes").getDocuments();

    await Future.forEach(snapshot.documents, (document) async {
      // ClassData data = ClassData.fromMap(document.data);
      await Firestore.instance
          .collection("Classes")
          .document(document.documentID)
          .collection("Homework")
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          if (element.data['uid'] == tutor.docid) {
            totalContributions++;
          }
        });
      });
      await Firestore.instance
          .collection("Classes")
          .document(document.documentID)
          .collection("Notes")
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          if (element.data['uid'] == tutor.docid) {
            totalContributions++;
          }
        });
      });
      await Firestore.instance
          .collection("Classes")
          .document(document.documentID)
          .collection("Tests")
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          if (element.data['uid'] == tutor.docid) {
            totalContributions++;
          }
        });
      });

      Firestore.instance
          .collection("Tutors")
          .document(tutor.docid)
          .updateData({"Contributions": totalContributions});
    });
  }

  void sumVotes(Tutor tutor) async {
    int totalVotes = 0;
    QuerySnapshot snapshot =
        await Firestore.instance.collection("Classes").getDocuments();

    await Future.forEach(snapshot.documents, (document) async {
      // ClassData data = ClassData.fromMap(document.data);
      await Firestore.instance
          .collection("Classes")
          .document(document.documentID)
          .collection("Homework")
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          if (element.data['uid'] == tutor.docid) {
            totalVotes += element.data['upvotes'] - element.data['downvotes'];
          }
        });
      });
      await Firestore.instance
          .collection("Classes")
          .document(document.documentID)
          .collection("Notes")
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          if (element.data['uid'] == tutor.docid) {
            totalVotes += element.data['upvotes'] - element.data['downvotes'];
          }
        });
      });
      await Firestore.instance
          .collection("Classes")
          .document(document.documentID)
          .collection("Tests")
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          if (element.data['uid'] == tutor.docid) {
            totalVotes += element.data['upvotes'] - element.data['downvotes'];
          }
        });
      });

      Firestore.instance
          .collection("Tutors")
          .document(tutor.docid)
          .updateData({"Contributions": totalVotes});
    });
  }

  List<Tutor> _tutorsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      if (doc.data['classes'] != null) {
        return Tutor(
          contributions: doc.data['Contributions'] ?? 0,
          firstName: doc.data['firstname'] ?? '',
          rating: doc.data['rating'] ?? 0,
          docid: doc.documentID,
          classes: doc.data['classes'].cast<String>() ?? [],
          rate: doc.data['rate'] ?? 0,
          totalVotes: doc.data['totalvotes'] ?? 0,
        );
      } else {
        return Tutor(
          contributions: doc.data['Contributions'] ?? 0,
          firstName: doc.data['firstname'] ?? '',
          rating: doc.data['rating'] ?? 0,
          docid: doc.documentID,
          classes: [],
          rate: doc.data['rate'] ?? 0,
          totalVotes: doc.data['totalvotes'] ?? 0,
        );
      }
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        firstName: snapshot.data['firstname'] ?? "",
        rating: snapshot.data['rating'] ?? "",
        classes: snapshot.data['classes'] ?? "");
  }

  Stream<UserData> get userdata {
    print("some things " + uid);

    return tutorsCollection
        .document(uid)
        .snapshots()
        .map((DocumentSnapshot userdata) => _userDataFromSnapshot(userdata));
  }

  Stream<List<Homework>> get homeworks {
    return hworkCollection.snapshots().map((_hworkFromSnapshot));
  }

  List<Homework> _hworkFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {}).toList();
  }

  ClassData getClass(String classid) {
    classesCollection.document(classid).collection("Homeworks").getDocuments();
  }
}

void getTheClasses(ClassDataNotifier classDataNotifier) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection("Classes").getDocuments();

  List<ClassData> _classList = List<ClassData>();

  Future.forEach(snapshot.documents, (document) async {
    // ClassData data = ClassData.fromMap(document.data);
    QuerySnapshot pre = await Firestore.instance
        .collection("Classes")
        .document(document.documentID)
        .collection("Pre")
        .getDocuments();

    List<Preq> _preList = List<Preq>();

    pre.documents.forEach((preClass) {
      Preq preqData = Preq.fromMap(preClass.data);

      if (preClass.data != null) {
        _preList.add(preqData);
      }
    });

    ClassData data =
        ClassData.fromMap(document.data, document.documentID, _preList);

    if (data != null) {
      _classList.add(data);
    }
  });

  classDataNotifier.classes = _classList;
}
