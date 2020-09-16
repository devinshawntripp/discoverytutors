import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'classMaterialModel.dart';

class User {
  final String uid;
  final String email;

  User({this.uid, this.email});
}

// class UserData {
//   String uid;
//   String firstName;
//   int rating;
//   List<String> classes;
//   List<ClassData> classList = List<ClassData>();

//   UserData.fromMap(Map<String, dynamic> data) {
//     firstName = data['firstname'] ?? "";
//     rating = data['rating'] ?? "";
//     classes = data['classes'].cast<String>() ?? "";
//   }

//   List<ClassData> get cs => classList;

//   set cs(List<ClassData> s) {
//     cs = s;
//   }

//   Future get getTheUserClasses async {
//     for (String c in classes) {
//       DocumentSnapshot classsnapshot =
//           await Firestore.instance.collection("Classes").document(c).get();

//       final data =
//           ClassData.fromUserMap(classsnapshot.data, classsnapshot.documentID);

//       if (data != null) {
//         classList.add(data);
//       }
//     }

//     cs = classList;
//   }

//   UserData.fromTestMap({this.uid});
//   UserData({this.firstName, this.rating, this.classes});
// }

// class AllClassesData {
//   final List<String> notes;
//   final List<String> homework;
//   final List<String> tests;

//   AllClassesData({this.notes, this.homework, this.tests});
// }

// class ClassDataNotifier extends ChangeNotifier {
//   List<ClassData> _classList;
//   ClassData _currentClass;
//   Stream<List<Homework>> thehomework;
//   Stream<List<Note>> _notes;
//   Stream<List<Test>> _tests;
//   UserData _user;

//   UnmodifiableListView<ClassData> get classList =>
//       UnmodifiableListView(_classList);

//   ClassData get currentClass => _currentClass;

//   List<ClassData> get classes => _classList;

//   String uid;

//   UserData get user => _user;

//   ClassDataNotifier({this.uid});

//   set user(UserData name) {
//     _user = name;
//     notifyListeners();
//   }

//   set homework(Stream<List<Homework>> s) {
//     thehomework = s;
//     notifyListeners();
//   }

//   set tests(Stream<List<Test>> s) {
//     _tests = s;
//     notifyListeners();
//   }

//   set notes(Stream<List<Note>> s) {
//     _notes = s;
//     notifyListeners();
//   }

//   Stream<List<Note>> get notes {
//     return Firestore.instance
//         .collection("Classes")
//         .document(_currentClass.classid)
//         .collection("Notes")
//         .snapshots()
//         .map((event) =>
//             event.documents.map((e) => Note.fromMap(e.data)).toList());
//   }

//   Stream<List<Test>> get tests {
//     return Firestore.instance
//         .collection("Classes")
//         .document(_currentClass.classid)
//         .collection("Tests")
//         .snapshots()
//         .map((event) =>
//             event.documents.map((e) => Test.fromMap(e.data)).toList());
//   }

//   Stream<List<Homework>> get homework {
//     // print(_currentClass.classid);
//     return Firestore.instance
//         .collection("Classes")
//         .document(_currentClass.classid)
//         .collection("Homework")
//         .snapshots()
//         .map((event) =>
//             event.documents.map((e) => Homework.fromMap(e.data)).toList());
//   }

//   Future<void> getTheUser(String uid) async {
//     DocumentSnapshot snapshot =
//         await Firestore.instance.collection("Tutors").document(uid).get();

//     user = UserData.fromMap(snapshot.data);
//     notifyListeners();
//   }

//   Future<void> getTheClasses() async {
//     QuerySnapshot snapshot =
//         await Firestore.instance.collection("Classes").getDocuments();

//     List<ClassData> _classList = List<ClassData>();

//     await Future.forEach(snapshot.documents, (document) async {
//       // ClassData data = ClassData.fromMap(document.data);
//       QuerySnapshot pre = await Firestore.instance
//           .collection("Classes")
//           .document(document.documentID)
//           .collection("Pre")
//           .getDocuments();

//       List<Preq> _preList = List<Preq>();

//       pre.documents.forEach((preClass) {
//         Preq preqData = Preq.fromMap(preClass.data);

//         if (preClass.data != null) {
//           _preList.add(preqData);
//         }
//       });

//       ClassData data =
//           ClassData.fromMap(document.data, document.documentID, _preList);

//       for (String c in user.classes) {
//         DocumentSnapshot classsnapshot =
//             await Firestore.instance.collection("Classes").document(c).get();
//         print("HERERED");

//         if (c == data.classid) {
//           data.picked = true;
//         }
//       }

//       if (data != null) {
//         _classList.add(data);
//       }
//     });

//     notifyListeners();

//     classes = _classList;
//   }

//   set classes(List<ClassData> s) {
//     _classList = s;
//     notifyListeners();
//   }

//   set currentClass(ClassData s) {
//     _currentClass = s;
//   }

//   void onChange() {
//     notifyListeners();
//   }
// }

class Preq {
  String classname;
  int etc;

  Preq.fromMap(Map<String, dynamic> data) {
    classname = data['Class'];
    etc = data['etc'];
  }

  Preq({this.classname});
}

class ClassData {
  String documentID;
  String classname;
  String classdescription;
  List<Preq> preq;
  String classid;
  bool picked = false;
  ClassData currentClass;

  Stream<List<Homework>> homeworks;
  Stream<List<Note>> notesList;
  Stream<List<Test>> testsList;

  set homework(Stream<List<Homework>> s) {
    homeworks = s;
  }

  set tests(Stream<List<Test>> s) {
    testsList = s;
  }

  set notes(Stream<List<Note>> s) {
    notesList = s;
  }

  Stream<List<Homework>> get homework {
    // final Firestore _firestore = Firestore.instance;
    return Firestore.instance
        .collection("Classes")
        .document(classid)
        .collection("Homework")
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Homework.fromMap(e.data)).toList());
  }

  Stream<List<Note>> get notes {
    // final Firestore _firestore = Firestore.instance;
    return Firestore.instance
        .collection("Classes")
        .document(classid)
        .collection("Notes")
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Note.fromMap(e.data)).toList());
  }

  Stream<List<Test>> get tests {
    // final Firestore _firestore = Firestore.instance;
    return Firestore.instance
        .collection("Classes")
        .document(classid)
        .collection("Tests")
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Test.fromMap(e.data)).toList());
  }

  ClassData({
    this.documentID,
    this.classname,
    this.classdescription,
    this.classid,
  });

  ClassData.fromUserMapStream(
      Map<String, dynamic> data, String docID, String uid) {
    classname = data['Title'] ?? "";
    classdescription = data['Description'] ?? "";
    documentID = docID;
    classid = data['classid'];

    List<String> tutorIds = data['tutors'].cast<String>();
    if (tutorIds.contains(uid)) {
      picked = true;
    } else {
      picked = false;
    }
  }

  ClassData.fromUserMap(Map<String, dynamic> data, String docID) {
    classname = data['Title'] ?? "";
    classdescription = data['Description'] ?? "";
    documentID = docID;
    classid = data['classid'];
  }

  ClassData.fromMap(Map<String, dynamic> data, String docID, List<Preq> p) {
    classname = data['Title'] ?? "";
    classdescription = data['Description'] ?? "";
    documentID = docID;
    classid = data['classid'];

    preq = p;
  }
}

List<String> takenClasses = [];

List<String> selectedUserClasses = [];
