import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/Services/auth.dart';
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
      'rate': rate,
    });
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
  ) async {
    
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
    });
  }

  Future registerStudent() async {}

  Stream<List<AllClassesData>> get allclasses {
    //some test code to see if this compiles
    Stream<List<AllClassesData>> something;

    return something;
  }

  Stream<List<Tutor>> get tutors {
    return tutorsCollection.snapshots().map(_tutorsListFromSnapshot);
  }

  List<Tutor> _tutorsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      if (doc.data['classes'] != null) {
        return Tutor(
          firstName: doc.data['firstname'] ?? '',
          rating: doc.data['rating'] ?? 0,
          docid: doc.documentID,
          classes: doc.data['classes'].cast<String>() ?? [],
          rate: doc.data['rate'] ?? 0,
        );
      } else {
        return Tutor(
          firstName: doc.data['firstname'] ?? '',
          rating: doc.data['rating'] ?? 0,
          docid: doc.documentID,
          classes: [],
          rate: doc.data['rate'] ?? 0,
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
    // print("some things " + uid);
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
